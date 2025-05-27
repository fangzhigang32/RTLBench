# RTLBench: A Multi-Dimensional Benchmark Suite for Evaluating LLM-Generated RTL Code

## Repository Overview

This repository contains two main folders:

- **[`AutoEval`](./AutoEval)**: Code for automated evaluation.
- **[`RTLBench-Benchmark`](./RTLBench-Benchmark)**: A benchmark suite for evaluating code generation capabilities of large language models (LLMs).

## AutoEval Folder Structure

The [`AutoEval`](./AutoEval) folder includes two subdirectories:

1. **[`EvalExistBenchmark`](./AutoEval/RTLBench-Benchmark)**: Evaluates the quality of reference code in existing benchmarks.
   - To run: Execute `python verilatorLint.py`.

2. **[`RTLBench`](./AutoEval/RTLBench)**: Uses the RTLBench-Benchmark to evaluate LLM-generated code.
   - Configuration: Set `API_KEY` and `BaseURL` in [`RTLBench/api.txt`](./AutoEval/RTLBench/api.txt).
   - To run: Execute `python main.py`.

## Python Version

This project requires **Python 3.13.2**.

## Dependency Installation

A [`requirements.txt`](./AutoEval/requirements.txt) file is provided in the `AutoEval` directory. Install dependencies using:

```bash
pip install -r requirements.txt
