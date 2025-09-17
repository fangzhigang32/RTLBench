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
<!-- 这里开始是可滚动表格 -->
<div style="max-height: 200px; overflow: auto; margin-bottom: 20px;">
  
| 姓名 | 年龄 | 职业 | 城市 | 薪资 | 入职日期 | 邮箱 |
|------|------|------|------|------|----------|------|
| 张三 | 28 | 软件工程师 | 北京 | ￥15,000 | 2020-03-15 | zhangsan@example.com |
| 李四 | 35 | 产品经理 | 上海 | ￥20,000 | 2018-06-20 | lisi@example.com |
| 王五 | 42 | 销售总监 | 广州 | ￥25,000 | 2015-11-03 | wangwu@example.com |
| 赵六 | 26 | UI设计师 | 深圳 | ￥12,000 | 2021-09-12 | zhaoliu@example.com |
| 钱七 | 31 | 数据分析师 | 杭州 | ￥18,000 | 2019-04-25 | qianqi@example.com |
| 孙八 | 29 | 前端开发 | 南京 | ￥16,000 | 2020-08-17 | sunba@example.com |
| 周九 | 38 | 后端开发 | 成都 | ￥19,000 | 2017-02-14 | zhoujiu@example.com |
| 吴十 | 33 | 运维工程师 | 武汉 | ￥17,000 | 2018-12-30 | wushi@example.com |
| 郑十一 | 27 | 测试工程师 | 西安 | ￥13,000 | 2021-01-22 | zhengshiyi@example.com |
| 王十二 | 36 | 技术经理 | 苏州 | ￥23,000 | 2016-07-08 | wangshier@example.com |
| 刘十三 | 30 | 市场营销 | 天津 | ￥14,000 | 2019-11-11 | liushisan@example.com |
| 陈十四 | 39 | 人力资源 | 重庆 | ￥16,500 | 2015-05-19 | chenshisi@example.com |

</div>
