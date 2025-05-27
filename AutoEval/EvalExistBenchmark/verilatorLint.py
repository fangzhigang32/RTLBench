#################################################################################################
# Use verilator to check existing benchmarks
#################################################################################################

import os
import re
import subprocess
from pathlib import Path
import sys
import pandas as pd
from TimeLogger import TimeLogger

# Set Benchmark Path
Benchmark_Path = "./VGen"


# Processing verilator reports
def parse_verilator_structured(log_text):
    output = []
    violations = []
    index = 1
    for line in log_text.splitlines():
        if line.startswith('%Warning') or line.startswith('%Error') or line.startswith('%Info'):
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
                violations.append({
                    'File Name': filename,
                    'Violation Rule': f"{level}-{rule}",
                    'Code Line': line_no,
                    'Violation Message': message
                })
                index += 1
    return output, violations


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
        return result.stdout + result.stderr, result.returncode
    except subprocess.TimeoutExpired:
        return "Command timed out\n", 1
    except Exception as e:
        return f"Error executing command: {str(e)}", 1


# Run Verilator lint check
def run_verilator_lint(folder, verilog_file, report_path):

    # Ensure the result directory exists
    report_path = Path(report_path).resolve()  # Convert to absolute path
    report_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Run Verilator without shell redirection
    cmd_command = f"verilator --lint-only -Wall {verilog_file}"
    output, returncode = execute_command(folder, cmd_command)
    
    # Write output to report file
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(output)
    
    return output, returncode


# Save violation information to Excel
def save_violations_to_excel(violations, excel_path):

    if not violations:
        print("[Info] No violations found, skipping Excel file creation.", flush=True)
        return
    df = pd.DataFrame(violations, columns=['File Name', 'Violation Rule', 'Code Line', 'Violation Message'])
    excel_path = Path(excel_path).resolve()
    df.to_excel(excel_path, index=False, engine='openpyxl')
    print(f"[Info] Violations saved to {excel_path}", flush=True)


# Processing Verilog designs, only performing Verilator lint checks
def process_designs(verilog_dir=Benchmark_Path, result_dir="./result"):

    # Make sure the results directory exists
    result_dir = Path(result_dir).resolve()
    result_dir.mkdir(parents=True, exist_ok=True)
    
    # Get all Verilog files
    verilog_dir = Path(verilog_dir).resolve()
    verilog_files = [f for f in os.listdir(verilog_dir) if f.endswith(('.v', '.sv'))]
    total_files = len(verilog_files)
    print(f"[Info] Total Verilog Files: {total_files}", flush=True)
    print("-" * 80, flush=True)

    all_violations = []  # Collect all violation information

    for index, verilog_file in enumerate(verilog_files, 1):
        design_name = Path(verilog_file).stem
        print(f"[Info] Processing file: {verilog_file} ({index}/{total_files})", flush=True)

        # Lint check using Verilator
        print("[Info] Running Lint", flush=True)
        verilator_report = f"{design_name}.rpt"
        report_path = result_dir / verilator_report
        output, returncode = run_verilator_lint(verilog_dir, verilog_file, report_path)
        
        # Check if the report file is generated
        if not report_path.exists():
            print(f"[Error] Failed to generate report for {verilog_file}: {output}", flush=True)
            with open(report_path, 'w', encoding='utf-8') as f:
                f.write(f"Error: Verilator failed with output:\n{output}")
            continue
        
        # Processing Lint Reports处理Lint报告
        verilator_lint_content = ""
        with open(report_path, 'r', encoding='utf-8') as f:
            verilator_lint_content = f.read()
            if verilator_lint_content.strip():
                parsed_content, violations = parse_verilator_structured(verilator_lint_content)
                all_violations.extend(violations)  # Add to total violation list
                if parsed_content:
                    verilator_lint_content = "\n".join(parsed_content) + "\nExist Lint Error"
                else:
                    verilator_lint_content = "No Lint Error"
            else:
                verilator_lint_content = "No Lint Error"
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(verilator_lint_content)

    # Save violation information to Excel
    save_violations_to_excel(all_violations, result_dir / "violations.xlsx")

    print(f"[Info] Processing complete. Logs saved to {result_dir}", flush=True)

# Summarize Lint results
def summary_result(verilog_dir=Benchmark_Path, report_file="./result/summary_report.txt"):
   
    verilog_dir = Path(verilog_dir).resolve()
    verilog_files = [f for f in os.listdir(verilog_dir) if f.endswith(('.v', '.sv'))]
    total_files = len(verilog_files)
    report_file = Path(report_file).resolve()
    result_dir = report_file.parent
    result_dir.mkdir(parents=True, exist_ok=True)

    with open(report_file, 'w', encoding='utf-8') as outfile:
        for verilog_file in verilog_files:
            design_name = Path(verilog_file).stem
            rpt_file = f"{design_name}.rpt"
            rpt_path = result_dir / rpt_file

            outfile.write(f"# Design name: {design_name}\n")
            outfile.write("-" * 80 + "\n")

            if rpt_path.exists():
                try:
                    with open(rpt_path, 'r', encoding='utf-8') as rpt:
                        outfile.write("## Lint Result:\n")
                        outfile.write(rpt.read() + "\n")
                except Exception as e:
                    outfile.write(f"Error reading {rpt_path}: {str(e)}\n")
            else:
                outfile.write("## Lint Result:\nNo report generated\n")

            outfile.write("\n")
    return total_files

# # Count the number of Lint errors
def count_errors_from_summary(report_file, total_files):

    report_file = Path(report_file).resolve()
    lint_errors = 0
    detected_violations = []

    try:
        with open(report_file, 'r', encoding='utf-8') as file:
            content = file.read()

            # Extract Report
            design_sections = content.split("# Design name:")[1:]
            for section in design_sections:
                design_name = section.split("\n")[0].strip()

                lint_start = section.find("## Lint Result:\n")
                if lint_start == -1:
                    continue
                lint_content = section[lint_start + len("## Lint Result:\n"):]

                # Match Lint Violation Lines
                violation_lines = [l for l in lint_content.splitlines() if re.match(r"^ID = \d+, Violation Rule:", l)]
                for vl in violation_lines:
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
                    lint_errors += 1

    except FileNotFoundError:
        print(f"Error: Summary report file {report_file} not found.", flush=True)
    except Exception as e:
        print(f"Error reading {report_file}: {str(e)}", flush=True)

    # Formatting Output
    summary_output = f"Total Files Processed: {total_files}\nlint_errors: {lint_errors}\n"

    if detected_violations:
        summary_output += "Detected Violations:\n"
        for v in detected_violations:
            summary_output += f"Violation Rule: [{v['Rule']}]. File Name: {v['File']}.v. Code Line: {v['Line']}. Violation Message: {v['Message']}\n"

    with open(report_file, 'w', encoding='utf-8') as outfile:
        new_content = summary_output + '\n\n' + content
        outfile.write(new_content)
    return lint_errors

# Main function
def main():

    log_file = Path("./result/lint.log").resolve()
    Path("./result").mkdir(parents=True, exist_ok=True)
    sys.stdout = TimeLogger(log_file)
    sys.stderr = sys.stdout

    # Execute design process
    process_designs()

    # Generate summary report
    report_file = "./result/summary_report.txt"
    total_files = summary_result()

    # Statistical Errors
    count_errors_from_summary(report_file, total_files)


if __name__ == "__main__":
    main()
