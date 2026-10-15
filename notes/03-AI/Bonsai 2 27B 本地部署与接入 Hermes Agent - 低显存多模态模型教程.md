---
title: Bonsai 2 27B 本地部署与接入 Hermes Agent
date: 2026-09-20
slug: "bonsai-2-27b-本地部署与接入-hermes-agent---低显存多模态模型教程"
tags: [AI, 大模型, 本地部署, llama.cpp, GGUF, 多模态, 视觉模型, Qwen, Hermes-Agent, OpenAI-兼容接口, Windows, GPU推理, Apple-Silicon, macOS, MLX, Metal, 教程, 中文, 低显存]
categories: [AI]
draft: false
source: "https://www.xgdn.com/79.html"
author: "X超哥"
---

## 简介

本文介绍如何在 Windows 上部署 PrismML 的 Ternary-Bonsai-2-27B GGUF 模型，并通过 llama.cpp 提供 OpenAI 兼容 API，供 Hermes Agent 调用。文章将该模型描述为基于 Qwen3.8-27B 的约 9 倍压缩版本：主模型约 5.9GB，并支持最长 262K 上下文与图片输入。

> 来源发布于 2026-09-19。模型能力、压缩比例及硬件需求均为原文说法，实际效果应以模型仓库、发布说明和本机测试为准。

## 模型文件与选择

下载来源：

- Hugging Face：<https://huggingface.co/prism-ml/Ternary-Bonsai-2-27B-gguf/tree/main>
- 专用 llama.cpp Release：<https://github.com/PrismML-Eng/llama.cpp/releases>

原文列出的文件选择：

| 文件 | 大小 | 原文建议 |
| --- | ---: | --- |
| `Ternary-Bonsai-2-27B-PTQ1_0` | 约 5.95GB | 8GB+ 显存，极致压缩 |
| `Ternary-Bonsai-2-27B-PQ2_0` | 约 7.21GB | 8GB+ 显存，较高精度 |
| `Ternary-Bonsai-2-27B-F16` | 约 53.8GB | 64GB+ 显存，完整精度 |
| `Ternary-Bonsai-2-27B-mmproj-Q8_0` | 约 629MB | 多模态投影文件 |
| `Ternary-Bonsai-2-27B-mmproj-BF16` | 约 931MB | 高精度多模态投影文件 |

建议优先核对模型卡中的 GGUF 文件名、量化格式和所需专用运行时；主模型与 `mmproj` 文件需配套。

## Apple Silicon：MLX 2-bit 部署方案

适用对象：搭载 Apple Silicon 的 macOS 设备（MLX/Metal 后端）。该方案使用 `Ternary-Bonsai-2-27B-mlx-2bit`，与 Windows/CUDA 的 GGUF + llama.cpp 方案不同，不能混用模型文件或启动参数。

模型页：<https://modelscope.cn/models/prism-ml/Ternary-Bonsai-2-27B-mlx-2bit>

### 已核对的模型包特性

| 项目 | MLX 2-bit 包 |
| --- | --- |
| 底座 | Qwen3.8-27B |
| 磁盘大小 | 约 8.60GB（语言模型 7.67GB + 视觉塔 0.92GB） |
| 权重格式 | Ternary g128；MLX 容器的有效存储约 2.25 bit/weight |
| 多模态 | 包含 FP16 视觉塔，无需单独下载 GGUF `mmproj` |
| 最大上下文 | 262K token（模型声明值；实际受统一内存和 KV Cache 制约） |
| 运行时 | 必须使用模型包 `runtime/` 中提供的加载器 |

模型卡特别说明：普通 MLX/`mlx-vlm` 加载器不会应用该模型所需的激活变换与逆 embedding 查找，可能产生错误输出且不报错。因此不得直接以通用 `mlx_lm` 或未替换 loader 的 `mlx-vlm` 运行本模型。

### 安装与下载

建议使用独立虚拟环境，并确保 `python3` 为原生 arm64 版本（不要在 Rosetta x86_64 Python 中运行）：

```bash
mkdir -p ~/models && cd ~/models
python3 -m venv bonsai-mlx-venv
source bonsai-mlx-venv/bin/activate
python -m pip install --upgrade pip huggingface_hub

# 官方模型卡给出的下载命令；约 8.6GB
hf download prism-ml/Ternary-Bonsai-2-27B-mlx-2bit \
  --local-dir bonsai2-27b-mlx

# 安装模型包附带的、匹配此格式的运行时依赖
pip install -r bonsai2-27b-mlx/runtime/requirements.txt
```

如果从 ModelScope 下载镜像，应保证下载结果完整保留 `runtime/`、配置文件、视觉处理器文件及 `model.safetensors`；不要只下载 `model.safetensors`。

### 文本与图片推理验证

保存为 `test_bonsai_mlx.py`，在上述虚拟环境中运行。文本模式将 `images` 传为空列表；图片模式传入本地图片路径。

```python
import sys

MODEL_DIR = "/Users/你的用户名/models/bonsai2-27b-mlx"
sys.path.insert(0, f"{MODEL_DIR}/runtime")

from vision_artifact import load_vl_model, chat_config
from mlx_vlm import generate
from mlx_vlm.prompt_utils import apply_chat_template

model, processor, config = load_vl_model(MODEL_DIR)
prompt = apply_chat_template(
    processor,
    chat_config(config),
    "用一句话介绍你自己。",
    num_images=0,
)
print(generate(model, processor, prompt, [], max_tokens=256, temperature=1.0))
```

图片验证时，将问题改为图片相关问题，并将最后一行中的 `[]` 改为 `['/绝对路径/photo.jpg']`，同时把 `num_images=0` 改为 `num_images=1`。

### Apple 硬件与参数建议

- 模型包约 8.6GB，但运行还需要统一内存供激活、KV Cache、Python 进程和系统使用；不要将磁盘大小等同于最低内存需求。
- 长上下文会显著增长 KV Cache 占用。首次运行建议从普通短提示开始，而非直接测试 64K/262K 上下文。
- 模型卡报告的测试数据包括 Apple M5 Pro 约 28.1 tok/s（PQ2_0、128 token 生成）以及旧测试栈中 M5 Max 约 47 tok/s；仅作作者测量参考，不能视为其他芯片的性能保证。
- 推理模式推荐：`temperature=1.0`、`top_p=0.95`、`top_k=20`、`min_p=0.0`。非推理/指令模式推荐：`temperature=0.7`、`top_p=0.80`、`top_k=20`、`min_p=0.0`、`presence_penalty=1.5`。
- 默认 reasoning effort 为 `xhigh`；模型卡建议需要更短回答时选 `medium`，并说明 `low` 不受支持。

### 与 Hermes Agent 的边界

当前模型卡提供的是 Python/MLX 推理 quickstart，并未提供可验证的 OpenAI 兼容 HTTP server 启动命令。因此不能直接沿用本文 GGUF 方案中的 `http://127.0.0.1:8085/v1` 配置给 Hermes Agent。

若要让 Hermes Agent 使用 Apple MLX 版本，必须先以该专用运行时实现或确认一个 OpenAI-compatible 服务层，并用 `curl <base-url>/models` 与一次 chat completion 实测通过后，再将该 Base URL、模型 ID 和非空 API Key 配入 Hermes 的 custom endpoint。没有这个服务层时，可在 Apple Silicon 上改用同权重的 GGUF 包配合 PrismML 专用 llama.cpp Metal 构建，以获得文章中同类的本地 HTTP 接口。

## Ubuntu：GGUF + PrismML llama.cpp 部署方案

适用对象：Ubuntu x86_64/arm64 的 CPU、NVIDIA CUDA、AMD ROCm 或 Vulkan 环境。Bonsai 2 的 `PTQ1_0`/`PQ2_0` 格式目前依赖 PrismML 的 llama.cpp fork；不要使用 stock `ggml-org/llama.cpp`，否则可能被拒绝加载，或在某些格式下加载后输出异常。

推荐使用官方 `Bonsai-demo` 自动完成运行时、模型和启动脚本的选择；它会按环境选择 PrismML 的预编译 llama.cpp，并下载 GGUF 主模型及 27B 所需的视觉投影文件。

### 后端与前置条件

| Ubuntu 硬件 | 推荐运行时 | 官方预编译包覆盖 |
| --- | --- | --- |
| NVIDIA GPU | CUDA | Linux x64 CUDA 12.4、12.8（Release 亦可能提供更新 CUDA 版本） |
| AMD GPU | ROCm | Ubuntu x64 ROCm 7.2 |
| NVIDIA / AMD / Intel GPU | Vulkan | Ubuntu x64 / arm64 Vulkan |
| 无独显 | CPU | Ubuntu x64 / arm64 CPU |

- NVIDIA：先以 `nvidia-smi` 检查驱动和可用显存；选择与驱动兼容的 CUDA 预编译包。若无匹配包，可用 demo 的 `scripts/build_cuda_linux.sh` 源码构建。
- AMD：先确认 `rocminfo` 或 `rocm-smi` 可用；ROCm 构建/预编译包应与系统 ROCm 版本匹配。
- CPU/Vulkan 路径可以运行，但 27B 的实际速度和内存需求取决于具体硬件；建议先用较小上下文验证，不把模型文件大小当作系统内存需求。

### 推荐安装：官方 demo 自动部署

```bash
sudo apt update
sudo apt install -y git build-essential curl

git clone https://github.com/PrismML-Eng/Bonsai-demo.git
cd Bonsai-demo

# 显式指定 Bonsai 2 27B；跳过非必要的 Open WebUI 与代码解释器，减少下载与依赖
BONSAI_FAMILY=bonsai2 BONSAI_MODEL=27B \
BONSAI_OPENWEBUI=0 BONSAI_CODE_INTERPRETER=0 \
./setup.sh
```

`setup.sh` 会检查基础依赖，安装 `uv` 和 Python 环境，下载模型，并选择匹配的 PrismML llama.cpp 二进制。模型仓库公开时通常不需要 Hugging Face Token。

### 启动本地 OpenAI-compatible 服务

首次建议以较小上下文启动。`BONSAI_NGL` 留空时由脚本自动判断 GPU 卸载层数；CPU-only 时显式设为 `0`。

```bash
cd ~/Bonsai-demo

# NVIDIA / ROCm / Vulkan：脚本自动选择可用后端；服务仅监听本机 8080 端口
BONSAI_FAMILY=bonsai2 BONSAI_MODEL=27B \
BONSAI_CTX=8192 \
./scripts/start_llama_server.sh
```

可选调优：

```bash
# 需要更长上下文时逐步增加；4-bit KV Cache 可显著降低长上下文内存占用，但会稍影响解码速度
BONSAI_FAMILY=bonsai2 BONSAI_MODEL=27B \
BONSAI_CTX=32768 BONSAI_KV4=1 \
./scripts/start_llama_server.sh

# 强制 CPU-only
BONSAI_FAMILY=bonsai2 BONSAI_MODEL=27B BONSAI_NGL=0 \
BONSAI_CTX=4096 ./scripts/start_llama_server.sh
```

默认地址为 `http://127.0.0.1:8080`，内置 API 路径为 `/v1/chat/completions`。不要将 `BONSAI_HOST` 设为 `0.0.0.0` 直接暴露到公网；该服务默认没有适合公网的认证与访问控制。

### 启动后验证

另开一个终端，先确认模型列表和一次真实推理请求均正常：

```bash
curl -fsS http://127.0.0.1:8080/v1/models

curl -fsS http://127.0.0.1:8080/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "Ternary-Bonsai-2-27B",
    "messages": [{"role": "user", "content": "用一句话说明你是谁。"}],
    "max_tokens": 128,
    "temperature": 1.0
  }'
```

如果 `/v1/models` 中返回的实际 model ID 与示例不同，应以返回值为准替换第二条请求中的 `model` 字段。出现库缺失或 CUDA/ROCm 不兼容错误时，优先换用与驱动/运行时匹配的 PrismML Release 包；不要改用 stock llama.cpp 绕过该要求。

### Hermes Agent 接入（Ubuntu）

完成上述两项验证后，Ubuntu 上的 GGUF 服务可作为 Hermes 的 custom OpenAI-compatible endpoint：

- Base URL：`http://127.0.0.1:8080/v1`
- Model：`/v1/models` 返回的实际模型 ID
- API Key：使用 Hermes custom endpoint 所要求的任意非空占位值；llama-server 本身通常不校验它

若 Hermes 与 llama-server 不在同一台主机，应通过受认证的反向代理、VPN 或 SSH 隧道访问；不要仅靠将 `BONSAI_HOST=0.0.0.0` 公开端口。

## llama.cpp 部署要点

1. 根据硬件下载 PrismML-Eng 发布的 llama.cpp 构建版本：CPU、CUDA 12.4、Vulkan 或 HIP/ROCm。
2. Windows 上使用 CUDA 版本时，按原文提醒同时下载对应 DLL 压缩包，并将其内容解压到程序根目录。
3. 在 llama.cpp 根目录创建 `models` 目录，放入主模型和 `mmproj` 文件。
4. 用 `llama-server.exe` 启动本地 API 服务。原文的 `llama.ccp` 应为 `llama.cpp` 的笔误。

参考启动脚本（将主模型文件名替换为实际下载文件名）：

```bat
@echo off
title Ternary-Bonsai-2-27B - llama.cpp
cd /d "%~dp0"

llama-server.exe ^
  -m "models\Ternary-Bonsai-2-27B-PTQ1_0.gguf" ^
  --mmproj "models\Ternary-Bonsai-2-27B-mmproj-BF16.gguf" ^
  --host 127.0.0.1 ^
  --port 8085 ^
  -c 65536 ^
  -ngl 99 ^
  -fa on ^
  --jinja ^
  --parallel 1 ^
  --alias Ternary-Bonsai-2-27B ^
  --temp 1.0 ^
  --top-p 0.95 ^
  --top-k 20 ^
  --min-p 0 ^
  --repeat-penalty 1.0 ^
  --cache-type-k q8_0 ^
  --cache-type-v q8_0 ^
  --reasoning on ^
  -n 32768
pause
```

## 关键参数速查

| 参数 | 用途 |
| --- | --- |
| `-m` | 主模型 GGUF 文件 |
| `--mmproj` | 图片理解所需的多模态投影文件 |
| `--host 127.0.0.1` | 仅监听本机，避免直接暴露服务 |
| `--port 8085` | 服务端口；控制台通常为 `http://127.0.0.1:8085` |
| `-c 65536` | 64K 上下文；上下文越大，KV Cache 内存/显存占用越高 |
| `-ngl 99` | 尽量将可用层卸载到 GPU |
| `-fa on` | 启用 Flash Attention；需运行时和硬件支持 |
| `--jinja` | 使用模型提供的 Jinja Chat Template |
| `--parallel 1` | 单并发请求 |
| `--alias` | 在 API 中暴露的模型 ID |
| `--cache-type-k/v q8_0` | 以 Q8_0 量化 KV Cache，降低长上下文内存开销 |
| `--reasoning on` | 按该专用构建启用推理模式；应先确认版本是否支持 |
| `-n 32768` | 单次响应上限；不等于上下文长度 |

## 接入 Hermes Agent

llama-server 启动后，服务为 OpenAI 兼容接口：

- Base URL：`http://127.0.0.1:8085/v1`
- 模型名：`Ternary-Bonsai-2-27B`（与 `--alias` 保持一致）
- API Key：原文称可填写任意非空值；具体仍取决于 Hermes Agent 的 Provider 配置校验。

接入前建议先验证服务：

```bash
curl http://127.0.0.1:8085/v1/models
```

确认返回的模型 ID 与 Hermes 配置一致后，再在 Hermes 中配置 OpenAI-compatible Provider。由于原文未提供完整 Hermes 配置示例，实际配置应以 Hermes 官方文档和当前版本的 Provider 配置规则为准。

## 风险与实践建议

- 不要将 `--host` 改成公网可访问地址，除非已设置认证、反向代理和网络访问控制。
- `-c 65536` 与 `-n 32768` 对内存/显存压力较大；低显存设备应从较小上下文和输出长度开始测试。
- 使用模型卡或 Release 附带的 chat template；模板不匹配会影响工具调用和多轮对话质量。
- 图片能力依赖正确的 `mmproj` 文件和运行时兼容性，应单独测试图片输入。
- 原文的硬件示例为 RTX 4080 SUPER 16GB、AMD R9 7900X、64GB 内存，不能视为所有量化版本的保证配置。

## 链接

- 原文：<https://www.xgdn.com/79.html>
- 模型文件：<https://huggingface.co/prism-ml/Ternary-Bonsai-2-27B-gguf/tree/main>
- 专用 llama.cpp：<https://github.com/PrismML-Eng/llama.cpp/releases>
- Hermes Agent：<https://hermes-agent.nousresearch.com/>
