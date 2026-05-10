---
title: llmfit
date: 2026-05-11
slug: llmfit---本地硬件适配的-llm-模型推荐工具
tags: [open-source, github, llm, local-llm, model-selection, hardware-detection, inference, benchmarking, cli-tool, tui, rust, ollama, llama-cpp, mlx, lm-studio, vllm, ai-tools]
categories: [AI]
draft: false
source: https://github.com/AlexsJones/llmfit
author: AlexsJones
---

## 简介

llmfit 是一个用于“根据本机硬件选择合适 LLM 模型”的开源终端工具。它会检测系统的 CPU、内存、GPU/显存与推理后端，然后从大量模型与 provider 中评估哪些模型能跑、跑得好不好，并给出推荐排序。

项目一句话定位：Hundreds of models & providers. One command to find what runs on your hardware.

## 核心特性

- 自动检测硬件：系统 RAM、CPU 核心数、NVIDIA/AMD/Intel/Apple Silicon/Ascend 等 GPU 与显存。
- 模型适配评分：综合质量、速度、硬件适配度、上下文长度等维度，为模型生成分数。
- 支持交互式 TUI：默认启动终端 UI，可搜索、筛选、排序、比较模型。
- 支持经典 CLI/JSON 输出：适合脚本、Agent 或自动化流程调用。
- 支持多种本地运行时：Ollama、llama.cpp、MLX、Docker Model Runner、LM Studio、vLLM 等。
- 支持硬件模拟：可以覆盖 RAM/VRAM/CPU 参数，提前评估不同机器配置下的模型可运行性。
- 支持 Plan 模式：针对某个模型和上下文长度，反推所需最低/推荐硬件配置。
- 支持社区排行榜：通过 localmaxxing.com 查看真实用户在不同硬件上的 tok/s、TTFT、VRAM 使用数据。
- 支持本地推理 Benchmark：对本机正在运行的 Ollama/vLLM/MLX 模型进行实际推理测速。

## 典型使用场景

- 想知道自己的 Mac、PC 或服务器适合运行哪些本地 LLM。
- 在购买 GPU 或升级硬件前，模拟不同 VRAM/RAM 配置的模型适配情况。
- 为 Ollama、llama.cpp、MLX、vLLM 等本地推理环境选择合适模型与量化版本。
- 需要将模型推荐结果以 JSON 形式交给脚本、调度器或 AI Agent 使用。
- 对比理论估算与社区真实 benchmark，减少“模型能下载但跑不动/跑不快”的试错成本。

## 安装方式

macOS / Linux 可使用 Homebrew 或安装脚本：

```bash
brew install llmfit

curl -fsSL https://llmfit.axjns.dev/install.sh | sh
```

也可以通过 uv/pip、Docker/Podman 或从源码构建：

```bash
uv tool install -U llmfit
uvx llmfit

docker run ghcr.io/alexsjones/llmfit

git clone https://github.com/AlexsJones/llmfit.git
cd llmfit
cargo build --release
```

## 常用命令

```bash
# 启动交互式 TUI
llmfit

# 经典 CLI 表格输出
llmfit --cli

# 查看系统硬件检测结果
llmfit system

# 搜索模型
llmfit search "llama 8b"

# 输出推荐模型 JSON
llmfit recommend --json --limit 5

# 按用途推荐，例如 coding
llmfit recommend --json --use-case coding --limit 3

# 模拟 24GB 显存 + 64GB 内存机器
llmfit --memory=24G --ram=64G fit

# 规划某个模型需要的硬件
llmfit plan "Qwen/Qwen3-4B-MLX-4bit" --context 8192 --json

# 本地 provider 实测 benchmark
llmfit bench
llmfit bench --all
llmfit bench --provider ollama llama3.2
```

## TUI 亮点快捷键

- `/`：搜索模型。
- `f`：切换适配过滤条件。
- `s`：切换排序列。
- `p`：进入 Plan 模式，估算目标模型所需硬件。
- `S`：硬件模拟。
- `A`：高级配置，调整 TPS 估算与评分权重。
- `b`：社区排行榜。
- `I`：本地推理 benchmark。
- `m` / `c`：标记并比较模型。
- `d` / `D`：下载模型与下载管理。

## 技术信息

- 主要语言：Rust
- License：MIT
- Stars：25.7k+
- Forks：1.5k+
- 形态：CLI + TUI + Web dashboard + REST API
- 支持后端：Ollama、llama.cpp、MLX、Docker Model Runner、LM Studio、vLLM 等

## 链接

- GitHub: https://github.com/AlexsJones/llmfit
- 项目安装脚本: https://llmfit.axjns.dev/install.sh
- 社区 benchmark 数据源: https://localmaxxing.com
