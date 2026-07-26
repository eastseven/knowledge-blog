---
title: OpenWorker - Andrew Ng开源桌面AI同事
date: 2026-07-26
tags:
  - AI-Agent
  - open-source
  - desktop-agent
  - Andrew-Ng
  - aisuite
  - MCP
  - local-first
  - Tauri
  - Slack
  - 项目分析
---

# OpenWorker - Andrew Ng开源桌面AI同事

官网：https://openworker.com
GitHub：https://github.com/andrewyng/openworker

相关笔记：[[Hermes Agent 使用手册]]、[[Multica - 开源AI Agent管理平台]]、[[Agentic Design Patterns - AI Agent设计模式中文翻译]]

## 一、项目概览

OpenWorker 是 Andrew Ng（吴恩达）开源的桌面端 AI 同事（AI Coworker），核心定位是交付"完成的工作成果"而非对话——产出文档、Slack 回复、更新日历、整理收件箱，而不是给一份 to-do list。

- 状态：Open Beta，5k stars，66 issues，71 PRs，59 commits
- 许可：MIT
- 支持平台：macOS（Apple Silicon，已签名公证+自动更新）、Windows 10/11（未签名）
- 核心原则：local-first（本地优先）、bring your own model（模型自由）

## 二、架构设计

三层架构，全部运行在本地：

| 层 | 目录 | 技术栈 | 职责 |
|---|---|---|---|
| Desktop App | `surfaces/gui/` | React UI + Tauri Shell | 原生桌面壳 + GUI，监督 server 进程 |
| Local Agent Server | `coworker/` | Python + FastAPI，构建于 aisuite 之上 | 引擎 + 工具 + 连接器 |
| 底层能力 | — | 全部用你的密钥，在你的机器上运行 | 见下表分解 |

底层能力三列：

| 本地工具 | SaaS 集成 | 模型 |
|---|---|---|
| 文件 & 终端 | 25+ 连接器（Slack/GitHub/Jira/Notion 等） | 任意 Provider（OpenAI/Anthropic/Gemini/Ollama 等） |

另有 `stt/` 目录（Rust）提供语音输入 sidecar。

## 三、技术栈

后端 (coworker/)：
- Python 3.10+，FastAPI + uvicorn
- 核心：aisuite（Andrew Ng 的统一 LLM 库），git commit 固定版本
- MCP client (mcp>=1.1)：支持 stdio + streamable-http，自封装 async 层
- pydantic v2 数据校验
- pypdf + pypdfium2 处理 PDF（刻意避开 PyMuPDF 的 AGPL）
- croniter 定时任务调度
- DuckDuckGo（ddgs）做 keyless 默认搜索

前端 (surfaces/gui/)：
- React + Vite + Tauri (Rust 桌面壳)

语音 (stt/)：
- Rust 实现的 speech-to-text sidecar

## 四、模型 Provider 支持

原生实现（providers/ 目录，各有独立 provider 文件）：
- OpenAI、Anthropic、Gemini

通过 aisuite 覆盖：
- GLM(Z.ai)、DeepSeek、Kimi(Moonshot)、Qwen、MiniMax、Mistral、Grok(xAI)、Meta(Muse Spark)
- Together、Fireworks（开源权重模型）

本地：
- Ollama（完全本地运行）

Provider 管理组件：
- `router.py` — 模型路由
- `matrix.py` — 能力矩阵
- `capabilities.py` — 能力检测
- `registry.py` — 注册表

## 五、核心模块详解

coworker/ 目录揭示了完整能力矩阵：

agents/ — Agent 引擎
automation/ — 定时任务（cron 调度）：每日简报、周报、频道监控
connectors/ — 25+ SaaS 集成（核心卖点）
  ├─ Slack：@mention 触发本地 session
  ├─ GitHub / Jira / Notion / Linear / HubSpot
  ├─ Outlook / Gmail / Google Calendar / monday.com
  ├─ Browser Automation（Playwright）
  └─ MCP 通用接入（任何 MCP 工具可插入）
mcp/ — 自有 MCP 客户端层（async 封装）
memory/ — 会话记忆
personas/ — 人格配置（Markdown + YAML frontmatter）
server/ — FastAPI 服务端
skills/ — 技能系统
tools/ — 内置工具集
  ├─ files / directories — 文件操作
  ├─ shell — 终端命令执行
  ├─ git — 版本控制
  ├─ search — 搜索（默认 DuckDuckGo）
  ├─ plan / todo — 规划与任务管理
  ├─ subagent — 子 Agent 派发
  └─ ask — 用户交互
tui/ — 终端界面（Textual）
web/ — Web API 层

## 六、安全与审批机制

这是 OpenWorker 最值得借鉴的设计之一，一组协同模块构成企业级安全模型：

- `permissions.py` — 权限控制
- `risk.py` — 风险评估
- `audit.py` — 审计日志
- `secrets.py` — 密钥管理（本地 secret store）
- `workspace_trust.py` — 工作区信任机制
- `inbox.py` / `inbox_routing.py` — 审批收件箱
- `unattended.py` — 无人值守运行控制

核心规则：写操作、发消息、执行命令前必须经用户确认。无人值守运行时，请求暂存到 inbox 而非自动执行。

## 七、产品亮点

1. 交付成果而非对话——产出文件（文档、表格、报告、网页），不是聊天回复
2. Slack 深度集成——@mention 触发 → 本地桌面开 session → 工作完成 → 线程回复
3. 25+ 连接器 + MCP 通用扩展——覆盖主流办公工具，任何 MCP 工具可插入
4. 定时自动化——晨报、周报、频道监控，无人值守但有审批护栏
5. Approval-gated 安全模型——写操作需确认，适合企业场景

## 八、同类产品对比

| 维度 | OpenWorker | Claude Desktop | ChatGPT Desktop | Hermes Agent |
|------|-----------|----------------|-----------------|-------------|
| 开源 | MIT 完全开源 | 闭源 | 闭源 | 开源 |
| 模型自由度 | 任意 Provider + 本地 | 仅 Anthropic | 仅 OpenAI | 可配置多 Provider |
| 本地运行 | 全部本地 | 全部本地 | 云端为主 | CLI 本地为主 |
| SaaS集成 | 25+ 连接器 | MCP 工具 | GPTs/插件 | MCP + Skills |
| Slack集成 | 原生深度集成 | 无 | 无 | Gateway 模式 |
| 定时任务 | 内置 cron | 无 | 无 | Cron job |
| 桌面端 | Tauri 原生 | Electron | Electron | CLI/TUI |

## 九、不足与风险

- Open Beta 阶段，约 59 commits，代码量年轻
- Windows 尚未代码签名（SmartScreen 会警告）
- 强依赖 aisuite，pinned 到特定 git commit 而非 PyPI 发布版
- 文档目录（docs/）内容较少，主要靠 README
- 71 个开放 PR 说明团队 review 压力大
- README 明确表示"可能不批准与内部路线冲突的 PR"

## 十、参考价值

作为 Hermes Agent 用户，以下设计值得借鉴：

1. Approval-gated 安全模型——permissions + risk + audit 的组合，适合企业场景
2. Slack relay 架构——mention 触发本地 session 的模式，与 Hermes gateway 类似但方向不同
3. MCP 客户端封装——coworker/mcp/ 的 async 层，可参考 streamable-http 实现
4. Persona 系统——Markdown + YAML frontmatter 定义人格，与 Hermes skill 体系理念相近
5. Provider Router + Capability Matrix——多模型能力检测和路由，适合做多模型 fallback 策略
