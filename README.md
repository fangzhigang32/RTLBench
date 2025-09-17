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
# Category Table

下表展示了各类模块的分类、描述与数量。表格带有 **美观样式**（圆角、斑马纹、滚动、悬浮高亮、黑色/蓝色链接等），可在支持 HTML 的 Markdown 渲染器中使用（如 GitHub Pages、Docsify、VuePress、VSCode 插件等）。

---

<style>
:root{
  --bg-card: #ffffff;
  --bg-table: #ffffff;
  --text-main: #111827;
  --text-sub: #4b5563;
  --brand: #2563eb;
  --border: #e5e7eb;
  --row-alt: #f9fafb;
  --row-hover: #eef2ff;
  --shadow: 0 10px 25px rgba(0,0,0,.08);
  --radius: 16px;
  --th-h: 48px;
  --row-h: 48px;
}
@media (prefers-color-scheme: dark){
  :root{
    --bg-card: #0b0f16;
    --bg-table: #0f172a;
    --text-main: #e5e7eb;
    --text-sub: #9ca3af;
    --brand: #60a5fa;
    --border: #1f2937;
    --row-alt: #0b1220;
    --row-hover: #132035;
    --shadow: 0 10px 25px rgba(0,0,0,.35);
  }
}
.relative.border.shadow-lg{
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  overflow: hidden;
}
.category-table-container{
  max-height: calc(var(--th-h) + var(--row-h) * 6);
  overflow: auto;
  scrollbar-gutter: stable;
  background: var(--bg-table);
}
.category-table-container::-webkit-scrollbar{ width: 10px; }
.category-table-container::-webkit-scrollbar-thumb{
  background: linear-gradient(180deg, #d1d5db, #cbd5e1);
  border-radius: 999px;
}
@media (prefers-color-scheme: dark){
  .category-table-container::-webkit-scrollbar-thumb{
    background: linear-gradient(180deg, #334155, #1f2937);
  }
}
.category-table{ width:100%; border-collapse:separate; border-spacing:0; font-size:14px; color:var(--text-main); }
.category-table thead th{
  position: sticky; top:0; background: var(--bg-card);
  border-bottom: 1px solid var(--border);
  height: var(--th-h);
  font-weight: 700; font-size:12px; text-transform: uppercase; color: var(--text-sub);
}
.category-table th, .category-table td{
  padding: 14px 16px; text-align: center; border-bottom: 1px solid var(--border);
}
.category-table tbody tr:nth-child(odd){ background: var(--row-alt); }
.category-table tbody tr:hover{ background: var(--row-hover); }
.category-link{ color: var(--text-main); text-decoration:none; transition: color .18s ease; }
.category-link:hover{ color: var(--brand); }
</style>

<div class="relative border shadow-lg">
  <div class="category-table-container">
    <table class="category-table">
      <thead>
        <tr>
          <th>CATEGORY</th>
          <th>DESCRIPTION</th>
          <th>COUNT</th>
        </tr>
      </thead>
      <tbody>
        <tr><td><span class="category-link">Logic Gates</span></td><td>Basic digital logic gates including AND, OR, NOT, etc.</td><td>8</td></tr>
        <tr><td><span class="category-link">Multiplexers</span></td><td>Select one of many inputs and forward it to the output.</td><td>4</td></tr>
        <tr><td><span class="category-link">Demultiplexers</span></td><td>Route input to one of many outputs.</td><td>4</td></tr>
        <tr><td><span class="category-link">Encoders</span></td><td>Convert input lines into binary codes.</td><td>5</td></tr>
        <tr><td><span class="category-link">Decoders</span></td><td>Convert binary codes into output lines.</td><td>5</td></tr>
        <tr><td><span class="category-link">Comparators</span></td><td>Compare two values and output results.</td><td>3</td></tr>
        <tr><td><span class="category-link">Flip-Flops</span></td><td>Basic memory elements for binary storage.</td><td>5</td></tr>
        <tr><td><span class="category-link">Shift Registers</span></td><td>Serial or parallel data shifting/storage.</td><td>3</td></tr>
        <tr><td><span class="category-link">Counters</span></td><td>Binary/BCD and up/down counters.</td><td>6</td></tr>
        <tr><td><span class="category-link">State Machines</span></td><td>FSM designs for pattern detection/control.</td><td>4</td></tr>
        <tr><td><span class="category-link">Memory Modules</span></td><td>SRAM, DRAM, ROM, and FIFO buffers.</td><td>7</td></tr>
        <tr><td><span class="category-link">Arithmetic Units</span></td><td>Adders, subtractors, multipliers, dividers.</td><td>19</td></tr>
        <tr><td><span class="category-link">Floating Point Units</span></td><td>IEEE 754-compliant arithmetic modules.</td><td>4</td></tr>
        <tr><td><span class="category-link">Communication Interfaces</span></td><td>UART, SPI, and I2C protocol modules.</td><td>8</td></tr>
        <tr><td><span class="category-link">Clock & Reset Modules</span></td><td>Clock division/gating and reset sync.</td><td>9</td></tr>
        <tr><td><span class="category-link">DSP</span></td><td>FIR, FFT, CORDIC digital signal processing.</td><td>11</td></tr>
        <tr><td><span class="category-link">Error Detection and Correction</span></td><td>Detecting/correcting transmission errors.</td><td>7</td></tr>
        <tr><td><span class="category-link">Synchronization & Handshake</span></td><td>Data transfer between async domains.</td><td>4</td></tr>
        <tr><td><span class="category-link">Miscellaneous</span></td><td>Sorting, pulse generation, etc.</td><td>11</td></tr>
        <tr><td><span class="category-link">Functional Modules</span></td><td>Real-world apps: controllers, appliances.</td><td>25</td></tr>
        <tr><td><span class="category-link">IO Modules</span></td><td>General-purpose I/O modules.</td><td>2</td></tr>
        <tr><td><span class="category-link">Arbiters</span></td><td>Manage access to shared resources.</td><td>2</td></tr>
        <tr><td><span class="category-link">Converters</span></td><td>Convert binary to BCD or Gray code.</td><td>1</td></tr>
        <tr><td><span class="category-link">Crypto Modules</span></td><td>AES and SHA cryptographic modules.</td><td>2</td></tr>
        <tr><td><span class="category-link">AI Accelerators</span></td><td>Modules for CNN acceleration.</td><td>1</td></tr>
      </tbody>
    </table>
  </div>
</div>
