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
<div style="max-height: 250px; overflow: auto; margin: 20px 0; border: 1px solid #e1e4e8; border-radius: 6px;">
<table style="width: 100%; border-collapse: collapse;">
<thead style="position: sticky; top: 0; background: #f6f8fa; z-index: 1;">
<tr>
<th style="padding: 12px; text-align: left; border-bottom: 2px solid #e1e4e8;">姓名</th>
<th style="padding: 12px; text-align: left; border-bottom: 2px solid #e1e4e8;">年龄</th>
<th style="padding: 12px; text-align: left; border-bottom: 2px solid #e1e4e8;">职业</th>
<th style="padding: 12px; text-align: left; border-bottom: 2px solid #e1e4e8;">城市</th>
<th style="padding: 12px; text-align: left; border-bottom: 2px solid #e1e4e8;">薪资</th>
</tr>
</thead>
<tbody>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">张三</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">28</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">软件工程师</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">北京</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥15,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">李四</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">35</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">产品经理</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">上海</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥20,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">王五</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">42</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">销售总监</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">广州</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥25,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">赵六</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">26</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">UI设计师</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">深圳</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥12,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">钱七</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">31</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">数据分析师</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">杭州</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥18,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">孙八</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">29</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">前端开发</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">南京</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥16,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">周九</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">38</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">后端开发</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">成都</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥19,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">吴十</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">33</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">运维工程师</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">武汉</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥17,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">郑十一</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">27</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">测试工程师</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">西安</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥13,000</td></tr>
<tr><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">王十二</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">36</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">技术经理</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">苏州</td><td style="padding: 12px; border-bottom: 1px solid #e1e4e8;">￥23,000</td></tr>
</tbody>
</table>
</div>
