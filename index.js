
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#3b82f6",
                        secondary: "#10b981",
                    },
                    borderRadius: {
                        none: "0px",
                        sm: "2px",
                        DEFAULT: "4px",
                        md: "8px",
                        lg: "12px",
                        xl: "16px",
                        "2xl": "10px",
                        "3xl": "24px",
                        full: "9999px",
                        button: "4px",
                    },
                },
            },
        };
        document.querySelectorAll(".copy-btn").forEach((btn) => {
            btn.addEventListener("click", function () {
                const codeBlock = this.parentElement.querySelector("code");
                const range = document.createRange();
                range.selectNode(codeBlock);
                window.getSelection().removeAllRanges();
                window.getSelection().addRange(range);
                document.execCommand("copy");
                window.getSelection().removeAllRanges();
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-check mr-1"></i> Copied';
                setTimeout(() => {
                    this.innerHTML = originalText;
                }, 2000);
            });
        });
        document.querySelectorAll(".module-links").forEach((link) => {
            link.addEventListener("click", function (e) {
                e.preventDefault();
                window.location.href = "#";
            });
        });
        // Category链接点击事件（可根据需求修改跳转逻辑）
        document.querySelectorAll(".category-link").forEach((link) => {
            link.addEventListener("click", function (e) {
                e.preventDefault();
                // 此处可添加自定义跳转逻辑，例如：
                // window.location.href = '/category/' + this.textContent.toLowerCase().replace(/\s+/g, '-');
                console.log("点击了Category项：", this.textContent);
            });
        });
        document.addEventListener("DOMContentLoaded", function () {
            // 模型数据
            const modelData = [
                {
                    name: "o3-mini",
                    fullName: "o3-mini",
                    syntax: 89.38,
                    function: 51.25,
                    violations: 96,
                    clarity: 9.46,
                },
                {
                    name: "o4-mini",
                    fullName: "o4-mini",
                    syntax: 90.63,
                    function: 51.88,
                    violations: 86,
                    clarity: 9.24,
                },
                {
                    name: "o1",
                    fullName: "o1",
                    syntax: 92.5,
                    function: 56.88,
                    violations: 45,
                    clarity: 9.22,
                },
                {
                    name: "Grok-3",
                    fullName: "Grok-3",
                    syntax: 90.63,
                    function: 43.75,
                    violations: 108,
                    clarity: 8.7,
                },
                {
                    name: "Gemini-2.5-flash",
                    fullName: "Gemini-2.5-flash",
                    syntax: 65.0,
                    function: 36.25,
                    violations: 375,
                    clarity: 8.6,
                },
                {
                    name: "Deepseek-v3",
                    fullName: "Deepseek-v3",
                    syntax: 88.75,
                    function: 46.25,
                    violations: 100,
                    clarity: 8.69,
                },
                {
                    name: "GPT-4o",
                    fullName: "GPT-4o",
                    syntax: 91.88,
                    function: 46.25,
                    violations: 57,
                    clarity: 8.67,
                },
                {
                    name: "Grok-2",
                    fullName: "Grok-2",
                    syntax: 90.0,
                    function: 50.63,
                    violations: 112,
                    clarity: 8.66,
                },
                {
                    name: "Gemini-2.0-flash",
                    fullName: "Gemini-2.0-flash",
                    syntax: 77.5,
                    function: 38.13,
                    violations: 111,
                    clarity: 8.7,
                },
                {
                    name: "Claude-3-5-sonnet",
                    fullName: "Claude-3-5-sonnet",
                    syntax: 87.5,
                    function: 49.38,
                    violations: 45,
                    clarity: 8.56,
                },
                {
                    name: "Doubao-1.5-pro",
                    fullName: "Doubao-1.5-pro",
                    syntax: 77.5,
                    function: 46.25,
                    violations: 42,
                    clarity: 8.47,
                },
                {
                    name: "GPT-4o-mini",
                    fullName: "GPT-4o-mini",
                    syntax: 88.13,
                    function: 41.25,
                    violations: 107,
                    clarity: 8.46,
                },
                {
                    name: "o1-mini",
                    fullName: "o1-mini",
                    syntax: 85.63,
                    function: 46.88,
                    violations: 100,
                    clarity: 8.45,
                },
                {
                    name: "GPT-4",
                    fullName: "GPT-4",
                    syntax: 82.5,
                    function: 37.5,
                    violations: 90,
                    clarity: 8.44,
                },
                {
                    name: "Phi-4",
                    fullName: "Phi-4",
                    syntax: 67.5,
                    function: 33.13,
                    violations: 251,
                    clarity: 8.12,
                },
                {
                    name: "Qwen2.5-72B-Instruct",
                    fullName: "Qwen2.5-72B-Instruct",
                    syntax: 79.38,
                    function: 41.25,
                    violations: 129,
                    clarity: 8.06,
                },
                {
                    name: "Qwen2.5-32B-Instruct",
                    fullName: "Qwen2.5-32B-Instruct",
                    syntax: 76.88,
                    function: 38.13,
                    violations: 120,
                    clarity: 7.83,
                },
                {
                    name: "Qwen2.5-Coder-32B-Instruct",
                    fullName: "Qwen2.5-Coder-32B-Instruct",
                    syntax: 71.88,
                    function: 37.5,
                    violations: 178,
                    clarity: 7.83,
                },
                {
                    name: "Llama-2-70b",
                    fullName: "Llama-2-70b",
                    syntax: 74.38,
                    function: 27.5,
                    violations: 147,
                    clarity: 7.79,
                },
                {
                    name: "Llama-3.1-405b-instruct",
                    fullName: "Llama-3.1-405b-instruct",
                    syntax: 73.13,
                    function: 35.63,
                    violations: 260,
                    clarity: 7.66,
                },
                {
                    name: "Llama-3-sonar",
                    fullName: "Llama-3-sonar",
                    syntax: 75.0,
                    function: 29.38,
                    violations: 201,
                    clarity: 7.54,
                },
                {
                    name: "Moonshot-v1",
                    fullName: "Moonshot-v1",
                    syntax: 78.13,
                    function: 33.75,
                    violations: 181,
                    clarity: 7.39,
                },
                {
                    name: "GLM-4",
                    fullName: "GLM-4",
                    syntax: 53.75,
                    function: 15.0,
                    violations: 170,
                    clarity: 6.31,
                },
                {
                    name: "GPT-3.5",
                    fullName: "GPT-3.5",
                    syntax: 74.38,
                    function: 26.25,
                    violations: 118,
                    clarity: 6.89,
                },
            ];

            const maxNameLength = 10;

            // 配色方案
            const multiColors = [
                "#4E79A7",
                "#A0CBE8",
                "#F28E2B",
                "#FFBE7D",
                "#59A14F",
                "#8CD17D",
                "#B6992D",
                "#F1CE63",
                "#499894",
                "#86BCB6",
                "#E15759",
                "#FF9D9A",
                "#79706E",
                "#BAB0AC",
                "#D37295",
                "#FABFD2",
                "#B07AA1",
                "#D4A6C8",
                "#9D7660",
                "#D7B5A6",
                "#4E79A7",
                "#A0CBE8",
                "#F28E2B",
                "#FFBE7D",
            ];

            // 初始化4个图表
            initChart(
                "performanceChart1",
                "customTooltip1",
                "fullnameTooltip1",
                "syntax",
                "Syntax %",
                "{value}%",
                multiColors,
                true
            );
            initChart(
                "performanceChart2",
                "customTooltip2",
                "fullnameTooltip2",
                "function",
                "Function %",
                "{value}%",
                multiColors,
                true
            );
            initChart(
                "performanceChart3",
                "customTooltip3",
                "fullnameTooltip3",
                "violations",
                "Violations #",
                "{value}",
                multiColors,
                false,
                true
            );
            initChart(
                "performanceChart4",
                "customTooltip4",
                "fullnameTooltip4",
                "clarity",
                "Clarity Score",
                "{value}",
                multiColors,
                true
            );

            // 图表初始化函数
            function initChart(
                chartId,
                tooltipId,
                fullnameTooltipId,
                dataKey,
                title,
                valueFormatter,
                colors,
                sortDescending = true,
                isViolations = false
            ) {
                const chartDom = document.getElementById(chartId);
                const myChart = echarts.init(chartDom);
                const tooltip = document.getElementById(tooltipId);
                const fullnameTooltip = document.getElementById(fullnameTooltipId);
                const chartCard = chartDom.closest(".chart-card");

                // 数据排序
                let sortedData = [...modelData];
                if (chartId === "performanceChart3") {
                    sortedData.sort((a, b) => a[dataKey] - b[dataKey]);
                } else if (sortDescending) {
                    sortedData.sort((a, b) => b[dataKey] - a[dataKey]);
                } else {
                    sortedData.sort((a, b) => a[dataKey] - b[dataKey]);
                }

                // 设置颜色
                sortedData.forEach((item, index) => {
                    item.color = colors[index % colors.length];
                });

                // 处理显示名称（过长时截断）
                const displayNames = sortedData.map((item) => {
                    if (item.fullName.length > maxNameLength) {
                        return item.fullName.substring(0, maxNameLength - 3) + "...";
                    }
                    return item.fullName;
                });

                // 图表配置
                const option = {
                    animation: false,
                    backgroundColor: "#fff",
                    tooltip: {
                        show: false,
                        trigger: "axis",
                        axisPointer: { type: "shadow" },
                        backgroundColor: "rgba(255, 255, 255, 0.95)",
                        borderWidth: 0,
                        textStyle: { color: "transparent", fontSize: 0 },
                        formatter: function () {
                            return "";
                        },
                    },
                    grid: {
                        left: "5%",
                        right: "5%",
                        bottom: "1%",
                        top: "8%",
                        containLabel: true,
                    },
                    xAxis: {
                        type: "value",
                        axisLabel: {
                            formatter: valueFormatter,
                            fontSize: 15,
                            color: "#000",
                        },
                        position: "top",
                        max:
                            dataKey === "syntax" || dataKey === "function"
                                ? 100
                                : dataKey === "violations"
                                    ? 400
                                    : 10,
                        splitLine: {
                            show: true,
                            lineStyle: { color: "#e5e7eb", type: "dashed" },
                        },
                    },
                    yAxis: {
                        type: "category",
                        inverse: true,
                        data: displayNames,
                        axisLabel: {
                            fontSize: 12,
                            align: "right",
                            padding: [0, 5, 0, 0],
                            color: "#0aa7ef",
                            margin: 0,
                            rich: { a: { color: "#000", cursor: "pointer" } },
                            formatter: function (value, index) {
                                return "{a|" + value + "}";
                            },
                        },
                        axisLine: { show: false },
                        axisTick: { show: false },
                        offset: 10,
                    },
                    series: [
                        {
                            name: title,
                            type: "bar",
                            barWidth: 6,
                            barGap: "0%",
                            barCategoryGap: "0%",
                            label: {
                                show: true,
                                position: "right",
                                offset: [5, 0],
                                formatter: function (params) {
                                    return dataKey === "syntax" || dataKey === "function"
                                        ? params.value + "%"
                                        : params.value;
                                },
                                fontSize: 13,
                                color: "#0060dd",
                            },
                            emphasis: {
                                itemStyle: { shadowBlur: 10, shadowColor: "rgba(0, 0, 0, 0.3)" },
                            },
                            itemStyle: {
                                color: function (params) {
                                    return sortedData[params.dataIndex].color;
                                },
                                borderRadius: [0, 0, 0, 0],
                                shadowBlur: 0,
                                shadowColor: "rgba(0, 0, 0, 0)",
                                shadowOffsetX: 2,
                                shadowOffsetY: 2,
                            },
                            data: sortedData.map((item, index) => ({
                                value: item[dataKey],
                                name: displayNames[index],
                                fullName: item.fullName,
                                isTruncated: item.fullName.length > maxNameLength,
                            })),
                        },
                    ],
                };

                myChart.setOption(option);

                // 点击显示完整名称
                myChart.on("click", function (params) {
                    if (params.componentType === "series" && params.seriesType === "bar") {
                        const item = sortedData[params.dataIndex];
                        fullnameTooltip.style.display = "block";
                        fullnameTooltip.innerHTML = `<div style="font-size: 12px; font-weight: bold; line-height: 1.2;">${item.fullName}</div>`;
                        fullnameTooltip.style.width = "auto";
                        fullnameTooltip.style.maxWidth = "300px";

                        const cardRect = chartCard.getBoundingClientRect();
                        const relativeX = params.event.event.clientX - cardRect.left;
                        const relativeY = params.event.event.clientY - cardRect.top;
                        fullnameTooltip.style.left = relativeX + 10 + "px";
                        fullnameTooltip.style.top = relativeY + 10 + "px";

                        // 点击其他区域关闭
                        const closeHandler = function (e) {
                            if (
                                !fullnameTooltip.contains(e.target) &&
                                !chartCard.contains(e.target)
                            ) {
                                fullnameTooltip.style.display = "none";
                                document.removeEventListener("click", closeHandler);
                            }
                        };
                        setTimeout(() => {
                            document.addEventListener("click", closeHandler);
                        }, 100);
                    }
                });

                // 鼠标移动效果
                myChart.getZr().on("mousemove", function (params) {
                    if (params.offsetX < 200) {
                        const pointInPixel = [params.offsetX, params.offsetY];
                        const pointInGrid = myChart.convertFromPixel(
                            { seriesIndex: 0 },
                            pointInPixel
                        );
                        if (
                            pointInGrid &&
                            pointInGrid[1] >= 0 &&
                            pointInGrid[1] < sortedData.length
                        ) {
                            chartDom.style.cursor = "pointer";
                            return;
                        }
                    }
                    chartDom.style.cursor = "default";
                });

                myChart.getZr().on("mouseout", function () {
                    if (document.activeElement !== fullnameTooltip) {
                        fullnameTooltip.style.display = "none";
                    }
                    chartDom.style.cursor = "default";
                });

                // 响应式调整
                function updateChartHeight() {
                    chartDom.parentElement.style.height = "448px";
                    chartDom.style.height = "448px";
                    myChart.resize();
                }
                updateChartHeight();
                window.addEventListener("resize", function () {
                    myChart.resize();
                });
            }
        });