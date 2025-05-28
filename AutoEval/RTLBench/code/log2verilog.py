#################################################################################################
# Using log feedback to prompt large language models to generate more optimized code
#################################################################################################

import os
import sys
import re
from langchain.output_parsers.json import SimpleJsonOutputParser
from set_model import chatModel
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
from datetime import datetime
from TimeLogger import TimeLogger
import shutil


# Set folder path the location where the RTL code generated for the first time for the large language model is stored
DESC_DIR = "../nl2verilog"

# Set the RTL folder location for LLM-Generation
GENERATED_DIR = "../log2verilog"


# Record the processed module information, which is used to continue execution 
# from the current position after interruption
PROCESSED_MODULES_FILE = os.path.join(GENERATED_DIR, "processed_modules.txt")


# Load the processed module list
def load_processed_modules():

    if not os.path.exists(PROCESSED_MODULES_FILE):
        return set()
    try:
        with open(PROCESSED_MODULES_FILE, 'r', encoding='utf-8') as f:
            return set(line.strip() for line in f if line.strip())
    except Exception as e:
        print(f"Error reading processed modules file: {e}", flush=True)
        return set()


# Save processed module names to a file
def save_processed_module(module_name):

    try:
        with open(PROCESSED_MODULES_FILE, 'a', encoding='utf-8') as f:
            f.write(f"{module_name}\n")
    except Exception as e:
        print(f"Error saving processed module {module_name}: {e}", flush=True)


# Make sure the module's output directory exists
def ensure_output_directory(module_name):

    module_dir = os.path.join(GENERATED_DIR, module_name)
    os.makedirs(module_dir, exist_ok=True)

    return module_dir


# Extract module names from Verilog code
def extract_module_name_from_verilog(verilog_code):

    match = re.search(r'\bmodule\s+(\w+)\s*[\(;#]', verilog_code)
    if match:
        return match.group(1).lower()
    
    return f"module_{datetime.now().strftime('%H%M%S')}"


# Use the design requirements, first generated code, and simulation log
# to prompt the LLM to generate optimized Verilog code
def generate_log_verilog_code(requirement, source_code, simulation_log, score_content):

    system_template = "You are a chip design expert with twenty years of work experience."
    user_template = "<design requirement>:\n\n{requirement}\n\nBased on the above design requirement, the generated Verilog code is as follows. <Verilog code>:\n\n{verilog_code}\n\nBut the code has error or warning logs when simulating. <simulation log>:\n\n{simulation_log}\n\nBased on the evaluation indicators such as readability, completeness of comments, and semantic consistency between code and comments, the code score (between 0 and 10) is {score_content}. Please debug and fix the Verilog code according to the simulation log and design requirements to get higher score. Ensure the code is complete, follows Verilog-2001 syntax, and includes appropriate module declaration, ports, logic and comments. Do not include any testbench or simulation code. Provide only the Verilog code. Output only the generated verilog code, no additional interpretation. If there is text not related to the code, please use // to comment it out. Don't use ```Verilog and ``` wrap."

    prompt_template = ChatPromptTemplate.from_messages([
        ("system", system_template),
        ("user", user_template)
    ])

    output_parser = StrOutputParser()
    chain = prompt_template | chatModel | output_parser

    return chain.invoke({"requirement": requirement, "verilog_code": source_code, "simulation_log": simulation_log, "score_content": score_content})


# Processing a single hardware description
def process_description(requirement, source_code, simulation_log, score_content, module_name, index):

    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{current_time} Generating Verilog code for description {index + 1}", flush=True)

    try:
        # Generate optimized Verilog code
        verilog_code = generate_log_verilog_code(requirement, source_code, simulation_log, score_content)

        # Make sure the module output directory exists
        module_dir = ensure_output_directory(module_name)
        verilog_file_path = os.path.join(module_dir, f"{module_name}.v")

        # Saving Verilog Code
        with open(verilog_file_path, 'w') as f:
            f.write(verilog_code)

        # Record processed modules
        save_processed_module(module_name)

        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"{current_time} Verilog code has been saved to {verilog_file_path}", flush=True)

    except Exception as e:
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"{current_time} Error processing module {module_name}: {e}", flush=True)
        # Do not record failed modules so that they can be tried again next time


# Process all module subfolders in the input directory
def process_input_directory():

    if not os.path.exists(DESC_DIR):
        print(f"Running Error: {DESC_DIR} directory does not exist", flush=True)
        return

    # Loading processed modules
    processed_modules = load_processed_modules()

    # Get all module subfolders
    module_dirs = [d for d in os.listdir(DESC_DIR) if os.path.isdir(os.path.join(DESC_DIR, d))]
    print(f"Total of {len(module_dirs)} modules", flush=True)

    for i, module_name in enumerate(module_dirs):
        if module_name in processed_modules:
            current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print(f"{current_time} Skipping already processed module {module_name}", flush=True)
            continue

        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"{current_time} Processing Module {i + 1}/{len(module_dirs)}: {module_name}", flush=True)
        
        # Read design requirement file
        desc_file = os.path.join(DESC_DIR, module_name, "desc.txt")
        if not os.path.exists(desc_file):
            print(f"Running Error: {desc_file} not exist, skip this module", flush=True)
            continue

        try:
            with open(desc_file, 'r', encoding='utf-8') as f:
                description = f.read().strip()
        except Exception as e:
            print(f"Running Error: Failed to read {desc_file}: {e}, skip this module", flush=True)
            continue

        # Read the Verilog source code file generated for the first time
        source_file = os.path.join(DESC_DIR, module_name, f"{module_name}.v")
        source_code = ""
        if os.path.exists(source_file):
            try:
                with open(source_file, 'r', encoding='utf-8') as f:
                    source_code = f.read().strip()
            except Exception as e:
                print(f"Running Warning: Failed to read {source_file}: {e}, using empty source code", flush=True)
        else:
            print(f"Running Warning: {source_file} not exist, using empty source code", flush=True)

        # Reading log files
        simulation_log = ""
        log_content = ""  # Icarus Verilog log
        rpt_content = "## Lint Result:\n"  # Verilator log
        score_content = "" # LLM-as-judge log
        log_file = os.path.join(DESC_DIR, module_name, f"{module_name}.log")
        rpt_file = os.path.join(DESC_DIR, module_name, f"{module_name}.rpt")
        score_file = os.path.join(DESC_DIR, module_name, f"{module_name}.txt")

        # Reading Icarus Verilog log file contents
        if os.path.exists(log_file):
            try:
                with open(log_file, 'r', encoding='utf-8') as f:
                    log_content = f.read().strip() + "\n"
            except Exception as e:
                print(f"Running Warning: Failed to read {log_file}: {e}, skipping", flush=True)
        else:
            print(f"Running Warning: {log_file} not exist, skipping", flush=True)

        # Reading LLM-as-judge log file contents
        if os.path.exists(score_file):
            try:
                with open(score_file, 'r', encoding='utf-8') as f:
                    score_content = f.read().strip() + "\n"
            except Exception as e:
                print(f"Running Warning: Failed to read {score_file}: {e}, skipping", flush=True)
        else:
            print(f"Running Warning: {score_file} not exist, skipping", flush=True)
        
        # Reading Verilator log file contents
        if os.path.exists(rpt_file):
            try:
                with open(rpt_file, 'r', encoding='utf-8') as f:
                    rpt_content += f.read()
            except Exception as e:
                print(f"Running Warning: Failed to read {rpt_file}: {e}, skipping", flush=True)
        else:
            print(f"Running Warning: {rpt_file} not exist, skipping", flush=True)

        simulation_log = log_content + "\n" + rpt_content

        if description:
            process_description(description, source_code, simulation_log, score_content, module_name, i)
        else:
            print(f"Running Warning: {desc_file} is empty, skip this module", flush=True)


# Main function
def main():

    # Set the run log path
    log_file = "../log/log2verilog.log"
    sys.stdout = TimeLogger(log_file)
    sys.stderr = sys.stdout

    # Make sure the output directory exists
    os.makedirs(GENERATED_DIR, exist_ok=True)

    # Processing input directories
    process_input_directory()


if __name__ == "__main__":
    main()