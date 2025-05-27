# RTLBench: A Multi-Dimensional Benchmark Suite for Evaluating LLM-Generated RTL Code

## Repository Overview

This repository contains two main folders:

- **AutoEval**: Code for automated evaluation.
- **RTLBench-Benchmark**: A benchmark suite for evaluating code generation capabilities of large language models (LLMs).

## AutoEval Folder Structure

The `AutoEval` folder includes two subdirectories:

1. **EvalExistBenchmark**: Evaluates the quality of reference code in existing benchmarks.
   - To run: Execute `python verilatorLint.py`.

2. **RTLBench**: Uses the RTLBench-Benchmark to evaluate LLM-generated code.
   - Configuration: Set `API_KEY` and `BaseURL` in `RTLBench/api.txt`.
   - To run: Execute `python main.py`.

## Python Version

This project requires **Python 3.13.2**.

## Dependency Installation

A `requirements.txt` file is provided in the `AutoEval` directory. Install dependencies using:

```bash
pip install -r requirements.txt
