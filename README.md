# RTLBench: A Multi-Dimensional Benchmark Suite for Evaluating LLM-Generated RTL Code

[![Paper](https://img.shields.io/badge/ICCD%2725-Paper-blue)]()

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
