# RTLBench: A Multi-Dimensional Benchmark Suite for Evaluating LLM-Generated RTL Code

![Evaluation Flow](./LintEval_Overview.png)

---

## 🗂️ Repository Overview

This repository consists of two main components:

- `AutoEval`
  Automated evaluation framework for analyzing RTL code.

- `RTLBench-Benchmark` 
  A comprehensive benchmark suite for assessing code generation capabilities of large language models (LLMs) in RTL design.

---

## 📁 AutoEval Folder Structure

The `AutoEval` directory contains two key submodules:

### 1. `EvalExistBenchmark`

Evaluate the quality of reference RTL code in existing benchmarks.

- **Run Command**:
  ```bash
  python verilatorLint.py
  ```

### 2. `RTLBench`

Use RTLBench-Benchmark to evaluate LLM-generated RTL code.

- **Configuration**:  
  Edit [`api.txt`](./AutoEval/RTLBench/code/api.txt) to set your `API_KEY` and `BaseURL`.

- **Run Command**:
  ```bash
  python main.py
  ```
- **Experimental Results**:
  The experimental results will be stored in the `experiment/model_name/log` folder.
  - `summary_report.txt` file stores the results of the first evaluation.
  - `re_summary_report.txt` file stores the results of Log2BetterRTL post-optimization evaluation.
---

## 🐍 Python Environment

- **Required Version**: Python `3.13.2`

---

## 📦 Dependency Installation

Install project dependencies using the provided [`requirements.txt`](./AutoEval/requirements.txt):

```bash
pip install -r AutoEval/requirements.txt
```

---

## 📬 Contributions

Feel free to open issues or submit pull requests to improve the benchmark suite and evaluation tools.




----
| CATEGORY | DESCRIPTION | COUNT |
| :--- | :--- | :--- |
| Logic Gates | Basic digital logic gates including AND, OR, NOT, etc. | 8 |
| Multiplexers | Select one of many inputs and forward it to the output. | 4 |
| Demultiplexers | Route input to one of many outputs. | 4 |
| Encoders | Convert input lines into binary codes. | 5 |
| Decoders | Convert binary codes into output lines. | 5 |
| Comparators | Compare two values and output results. | 3 |
| Flip-Flops | Basic memory elements for binary storage. | 5 |
| Shift Registers | Serial or parallel data shifting/storage. | 3 |
| Counters | Binary/BCD and up/down counters. | 6 |
| State Machines | FSM designs for pattern detection/control. | 4 |
| Memory Modules | SRAM, DRAM, ROM, and FIFO buffers. | 7 |
| Arithmetic Units | Adders, subtractors, multipliers, dividers. | 19 |
| Floating Point Units | IEEE 754-compliant arithmetic modules. | 4 |
| Communication Interfaces | UART, SPI, and I2C protocol modules. | 8 |
| Clock & Reset Modules | Clock division/gating and reset sync. | 9 |
| DSP | FIR, FFT, CORDIC digital signal processing. | 11 |
| Error Detection and Correction | Detecting/correcting transmission errors. | 7 |
| Synchronization & Handshake | Data transfer between async domains. | 4 |
| Miscellaneous | Sorting, pulse generation, etc. | 11 |
| Functional Modules | Real-world apps: controllers, appliances. | 25 |
| IO Modules | General-purpose I/O modules. | 2 |
| Arbiters | Manage access to shared resources. | 2 |
| Converters | Convert binary to BCD or Gray code. | 1 |
| Crypto Modules | AES and SHA cryptographic modules. | 2 |
| AI Accelerators | Modules for CNN acceleration. | 1 |
