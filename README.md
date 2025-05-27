# RTLBench: A Multi-Dimensional Benchmark Suite for Evaluating LLM-Generated RTL Code

![Evaluation Flow](./LintEval_Overview.png)

---

## 🗂️ Repository Overview

This repository consists of two main components:

- [`AutoEval`](./AutoEval)  
  Automated evaluation framework for analyzing RTL code.
  
- [`RTLBench-Benchmark`](./RTLBench-Benchmark)  
  A comprehensive benchmark suite for assessing code generation capabilities of large language models (LLMs) in RTL design.

---

## 📁 AutoEval Folder Structure

The `AutoEval` directory contains two key submodules:

### 1. [`EvalExistBenchmark`](./AutoEval/EvalExistBenchmark)
Evaluate the quality of reference RTL code in existing benchmarks.

- **Run Command**:
  ```bash
  python verilatorLint.py
