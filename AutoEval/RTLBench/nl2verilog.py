#################################################################################################
# Using design requirements to prompt large language models to generate RTL code for the first time
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


# Set folder path
# Set design requirements and testbench location
DESC_DIR = "../desc_and_bench"  

# Set the RTL folder location for LLM-Generation
GENERATED_DIR = "../nl2verilog"  


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


# Use LLM to generate Verilog code directly from hardware description
def generate_verilog_code(user_input):

    system_template = "You are a chip design expert with twenty years of work experience."
    user_template = "Based on the following design requirement, generate synthesizable Verilog code. Ensure the code is complete, follows Verilog-2001 syntax, and includes appropriate module declaration, ports, logic and comments. Do not include any testbench or simulation code. <design requirement>:\n\n{requirement}\n\nOutput only the generated verilog code, no additional interpretation. If there is text not related to the code, please use // to comment it out. Don't use ```Verilog and ``` wrap."

    prompt_template = ChatPromptTemplate.from_messages([
        ("system", system_template),
        ("user", user_template)
    ])

    output_parser = StrOutputParser()
    chain = prompt_template | chatModel | output_parser

    return chain.invoke({"requirement": user_input})


# Processing a single design description
def process_description(user_input, module_name, index, processed_modules):

    # Print begin log
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{current_time} Generating Verilog code for description {index + 1}", flush=True)

    try:
        # Generating Verilog Code
        verilog_code = generate_verilog_code(user_input)

        # Make sure the module output directory exists
        module_dir = ensure_output_directory(module_name)
        verilog_file_path = os.path.join(module_dir, f"{module_name}.v")

        # Saving Verilog Code
        with open(verilog_file_path, 'w') as f:
            f.write(verilog_code)

        # Record processed modules
        save_processed_module(module_name)

        # Print finish log
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"{current_time} Verilog code has been saved to {verilog_file_path}", flush=True)

    except Exception as e:
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"{current_time} Error processing module {module_name}: {e}", flush=True)
        # Do not record failed modules so that they can be tried again next time


# Process all description files in the input directory
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
        
        # Read description file
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
        
        if description:
            process_description(description, module_name, i, processed_modules)
        else:
            print(f"Running Warning: {desc_file} is empty, skip this module", flush=True)


# Main function
def main():
    
    # Setting the log file location
    log_file = "../log/nl2verilog.log"
    sys.stdout = TimeLogger(log_file)
    sys.stderr = sys.stdout

    # Make sure the output directory exists
    os.makedirs(GENERATED_DIR, exist_ok=True)

    # Processing input directories
    process_input_directory()


if __name__ == "__main__":
    main()