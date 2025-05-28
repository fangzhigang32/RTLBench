#################################################################################################
# Evaluate code generated from large language models using Icarus Verilog, Verilator, and LLM-as-Judge.
#################################################################################################

import os
import re
import subprocess
import shutil
from pathlib import Path
import sys
from TimeLogger import TimeLogger
from langchain.output_parsers.json import SimpleJsonOutputParser
from set_model import judgeModel
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate


# Set log path
LOG_DIR = "../log"


# Record the processed module information, which is used to continue execution 
# from the current position after interruption
PROCESSED_DESIGNS_FILE = os.path.join(LOG_DIR, "processed_designs.txt")


# Processing Verilator Reports
def parse_verilator_structured(log_text):

    output = []
    index = 1

    for line in log_text.splitlines():
        if line.startswith('%Warning') or line.startswith('%Error'):
            match = re.match(r"%(\w+)-(\w+):\s+([\w./]+):(\d+):(\d+):\s+(.*)", line)
            if match:
                level, rule, filename, line_no, col_no, message = match.groups()
                entry = (
                    f"ID = {index}, Violation Rule: [{'-'.join([level, rule])}]. "
                    f"File Name: {filename}. "
                    f"Code Line: {line_no}. "
                    f"Violation Message: {message}"
                )
                output.append(entry)
                index += 1

    return output


# LLM as judge for evaluating Verilog code
# Use LLM to generate Verilog code directly from hardware description
def llm_evaluate_verilog_code(verilog_code):

    system_template = "You are a chip design expert with twenty years of work experience."
    user_template = "As a code judge, please rate the quality of the Verilog code provided to you. < Verilog code>:\n\n{verilog_code}\n\nEvaluation indicators include readability, comment completeness, semantic consistency of code and comments, etc. Give an integer score between 0 and 10. Output only an integer score, no additional interpretation."

    prompt_template = ChatPromptTemplate.from_messages([
        # ("system", system_template),
        ("user", user_template)
    ])

    output_parser = StrOutputParser()
    chain = prompt_template | judgeModel | output_parser

    return chain.invoke({"verilog_code": verilog_code})


# Execute shell commands in the specified folder
def execute_command(folder, cmd_command, timeout=None):

    try:
        result = subprocess.run(
            cmd_command,
            cwd=folder,
            shell=True,
            capture_output=True,
            text=True,
            encoding='utf-8',
            timeout=timeout
        )
        return result.stdout + result.stderr
    except subprocess.TimeoutExpired:
        return "Command timed out\n"
    except Exception as e:
        return f"Error executing command: {str(e)}"


# Run Verilator to Lint
def run_verilator_lint(folder, verilog_file, report_path):

    cmd_command = f"verilator --lint-only -Wall {verilog_file} &> {report_path}"

    output = execute_command(folder, cmd_command)

    return output


# Loading the processed design list
def load_processed_designs():

    if not os.path.exists(PROCESSED_DESIGNS_FILE):
        return set()
    try:
        with open(PROCESSED_DESIGNS_FILE, 'r', encoding='utf-8') as f:
            return set(line.strip() for line in f if line.strip())
    except Exception as e:
        print(f"Error reading processed designs file: {e}", flush=True)
        return set()


# Save the processed design name to a file
def save_processed_design(design_name):

    try:
        with open(PROCESSED_DESIGNS_FILE, 'a', encoding='utf-8') as f:
            f.write(f"{design_name}\n")
    except Exception as e:
        print(f"Error saving processed design {design_name}: {e}", flush=True)


# Process Verilog designs, including file copying, simulation, and Lint checking
def process_designs(nl2verilog_dir="../nl2verilog", desc_and_bench_dir="../desc_and_bench", output_file="../log/sim_and_lint.log"):

    # Loading processed design
    processed_designs = load_processed_designs()

    # Get the subfolder under nl2verilog
    design_folders = [d for d in os.listdir(nl2verilog_dir) if os.path.isdir(os.path.join(nl2verilog_dir, d))]
    total_folders = len(design_folders)

    # Print log
    print(f"[Info] Total Designs: {total_folders}", flush=True)
    print("-" * 80, flush=True)

    for index, design_name in enumerate(design_folders, 1):
        if design_name in processed_designs:
            print(f"[Info] Skipping already processed design: {design_name} ({index}/{total_folders})", flush=True)
            continue

        print(f"[Info] Processing design: {design_name} ({index}/{total_folders})", flush=True)

        try:
            # Use the nl2verilog subfolder directly as the working directory
            design_folder = Path(nl2verilog_dir) / design_name

            # Copy the Verilog file in desc_and_bench to nl2verilog
            desc_and_bench_subdir = os.path.join(desc_and_bench_dir, design_name)
            if os.path.exists(desc_and_bench_subdir):
                for file in os.listdir(desc_and_bench_subdir):
                    shutil.copy(os.path.join(desc_and_bench_subdir, file), design_folder)
            else:
                print(f"[Warning] No corresponding desc_and_bench subfolder found: {design_name}", flush=True)

            # Get Verilog and Testbench Files
            verilog_file = next((f for f in os.listdir(design_folder) if f.startswith(design_name) and f.endswith('.v')), None)
            testbench_file = f"tb_{design_name}.v"

            # 1.Simulation with Icarus Verilog
            if not verilog_file:
                print(f"[Warning] No Verilog file found: {design_name}.v", flush=True)
            elif not os.path.exists(os.path.join(design_folder, testbench_file)):
                print(f"[Warning] No testbench file found for {testbench_file}", flush=True)
            else:
                print("[Info] Running simulation", flush=True)

                # Performing syntax check
                cmd_command = f"iverilog -o sim {verilog_file} {testbench_file}"

                console_output1 = "## Syntax Result:\n"
                console_output1 += execute_command(design_folder, cmd_command)

                if console_output1 == "## Syntax Result:\n":
                    console_output1 += "No Syntax Error\n"
                else:
                    console_output1 += "Exist Syntax Error\n"

                # Performing simulation
                cmd_command2 = "vvp sim"

                console_output2 = "## Function Result:\n"
                console_output2 += execute_command(design_folder, cmd_command2, timeout=2)

                if "Command timed out" in console_output2 or "Unable to open input file" in console_output2:
                    console_output2 += "Exist Function Error\n"

                # Save simulation log
                simlog = os.path.join(design_folder, f"{design_name}.log")
                with open(simlog, 'w', encoding='utf-8') as f:
                    f.write(console_output1 + "\n")
                    f.write(console_output2)

                # Delete temporary scripts
                execute_command(design_folder, "rm sim")

            # 2.Lint check with Verilator
            if verilog_file:

                print("[Info] Running Lint", flush=True)
                verilator_report = f"{design_name}.rpt"

                # Performing Lint Checks
                run_verilator_lint(design_folder, verilog_file, verilator_report)
                
                verilator_lint_content = ""
                lintlog = os.path.join(design_folder, verilator_report)

                with open(lintlog, 'r', encoding='utf-8') as f:
                    verilator_lint_content = f.read()
                    if verilator_lint_content:
                        verilator_lint_content = "\n".join(parse_verilator_structured(verilator_lint_content))
                        verilator_lint_content += "\nExist Lint Error"
                    else:
                        verilator_lint_content = "No Lint Error"

                with open(lintlog, 'w', encoding='utf-8') as f:
                    f.write(verilator_lint_content)

            # 3.LLM as judge
            if verilog_file:

                print("[Info] Running Score", flush=True)

                verilog_code = ""
                source_code = os.path.join(design_folder, verilog_file)

                try:
                    with open(source_code, 'r', encoding='utf-8') as f:
                        verilog_code = f.read()

                    # Performing LLM as judge to get score
                    score = llm_evaluate_verilog_code(verilog_code)

                    score_file = os.path.join(design_folder, f"{design_name}.txt")
                    with open(score_file, 'w', encoding='utf-8') as score_log_file:
                        score_log_file.write(score)
                except Exception as e:
                    print(f"[Warning] Failed to read or score {source_code}: {e}", flush=True)

            # Mark design as processed status
            save_processed_design(design_name)

        except Exception as e:
            print(f"[Error] Processing design {design_name} failed: {e}", flush=True)
            # Failed designs are not recorded so that they can be tried again next time

    print(f"[Info] Processing complete. Logs saved to {output_file}", flush=True)


# Generates a summary of simulation and lint check results for all designs
def summary_result(verilog_dir, report_file):

    design_folders = [d for d in os.listdir(verilog_dir) if os.path.isdir(os.path.join(verilog_dir, d))]
    total_designs = len(design_folders)

    with open(report_file, 'w+', encoding='utf-8') as outfile:
        for subdir, _, files in os.walk(verilog_dir):
            folder_name = os.path.basename(subdir)
            # Icarus Verilog Log
            log_file = f"{folder_name}.log"
            # Verilator rpt
            rpt_file = f"{folder_name}.rpt"
            # LLM-as-judge txt
            score_file = f"{folder_name}.txt"

            log_path = os.path.join(subdir, log_file) if log_file in files else None
            rpt_path = os.path.join(subdir, rpt_file) if rpt_file in files else None
            score_path = os.path.join(subdir, score_file) if score_file in files else None

            if log_path or rpt_path or score_path:
                outfile.write(f"# Design name: {folder_name}\n")
                outfile.write("-" * 80 + "\n")

                if log_path:
                    try:
                        with open(log_path, 'r', encoding='utf-8') as log:
                            outfile.write(log.read())
                            outfile.write("\n## Lint Result:\n")
                    except Exception as e:
                        outfile.write(f"Error reading {log_path}: {str(e)}\n")

                if rpt_path:
                    try:
                        with open(rpt_path, 'r', encoding='utf-8') as rpt:                            
                            outfile.write(rpt.read() + "\n")
                    except Exception as e:
                        outfile.write(f"Error reading {rpt_path}: {str(e)}\n")
                
                if score_path:
                    try:
                        with open(score_path, 'r', encoding='utf-8') as score:
                            outfile.write("\n## Score Result(0-10):\n")
                            outfile.write(score.read() + "\n")
                    except Exception as e:
                        outfile.write(f"Error reading {score_path}: {str(e)}\n")

                outfile.write("\n")
    return total_designs


# Count syntax, functional and lint errors in aggregate reports
def count_errors_from_summary(report_file, total_designs):

    syntax_errors = 0
    function_errors = 0
    lint_errors = 0
    total_score = 0
    design_count = 0
    detected_violations = []

    try:
        with open(report_file, 'r', encoding='utf-8') as file:
            content = file.read()
            syntax_errors = content.count("Exist Syntax Error")
            function_errors = content.count("Exist Function Error")

            # Extract Report
            design_sections = content.split("# Design name:")[1:]
            for section in design_sections:
                design_name = section.split("\n")[0].strip()
                design_count += 1

                # Extracting scores
                score_match = re.search(r"## Score Result\(0-10\):\n(\d+)", section)
                if score_match:
                    total_score += int(score_match.group(1))

                lint_start = section.find("## Lint Result:\n")
                if lint_start == -1:
                    continue
                lint_content = section[lint_start + len("## Lint Result:\n"):]

                # Matches Lint violation lines in the format of "ID = [number], Violation Rule: [Severity-Rule]"
                violation_lines = [l for l in lint_content.splitlines() if re.match(r"^ID = \d+, Violation Rule:", l)]
                for vl in violation_lines:
                    # Parsing format: ID = 1, Violation Rule: [Warning-VARHIDDEN]. File Name: aes_encrypt_128.v. Code Line: 35. Violation Message: Declaration of signal hides declaration in upper scope: 'round'
                    match = re.match(r"ID = \d+, Violation Rule: \[(\w+)-([A-Z]+)\]\. File Name: ([^\.]+)\.v\. Code Line: (\d+)\. Violation Message: (.+)", vl)
                    if not match:
                        continue
                    severity, rule, file_name, line, message = match.groups()
                    detected_violations.append({
                        'Design': design_name,
                        'Rule': f"{severity}-{rule}",
                        'File': file_name,
                        'Line': line,
                        'Message': message
                    })
                    lint_errors += 1  # Increment for each valid violation

    except FileNotFoundError:
        print(f"Error: Summary report file {report_file} not found.", flush=True)
    except Exception as e:
        print(f"Error reading {report_file}: {str(e)}", flush=True)

    # Calculate the average score
    average_score = total_score / total_designs if total_designs > 0 else 0

    # Format output to match Lint report format
    summary_output = f"Total Designs Processed: {total_designs}\nsyntax_errors: {syntax_errors}\nfunction_errors: {function_errors}\nlint_errors: {lint_errors}\naverage_score: {average_score:.2f}\n"

    if detected_violations:
        summary_output += "Detected Violations:\n"
        for v in detected_violations:
            summary_output += f"Violation Rule: [{v['Rule']}]. File Name: {v['File']}.v. Code Line: {v['Line']}. Violation Message: {v['Message']}\n"

    with open(report_file, 'w', encoding='utf-8') as outfile:
        new_content = summary_output + '\n\n' + content
        outfile.write(new_content)
    return syntax_errors, function_errors, lint_errors


# Main function
def main():

    # set log path
    log_file = "../log/sim_and_lint.log"
    sys.stdout = TimeLogger(log_file)
    sys.stderr = sys.stdout

    # Make sure the log directory exists
    os.makedirs(LOG_DIR, exist_ok=True)

    # Execute design process
    process_designs()

    # Generate summary report
    verilog_dir = "../nl2verilog"
    report_file = "../log/summary_report.txt"
    total_designs = summary_result(verilog_dir, report_file)

    # Statistical Errors
    count_errors_from_summary(report_file, total_designs)


if __name__ == "__main__":
    main()