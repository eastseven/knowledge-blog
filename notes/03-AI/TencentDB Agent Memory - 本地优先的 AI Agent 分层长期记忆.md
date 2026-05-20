---
title: TencentDB Agent Memory
date: 2026-05-15
slug: "tencentdb-agent-memory---本地优先的-ai-agent-分层长期记忆"
tags: [github, open-source, ai-agent, llm, agent-memory, long-term-memory, short-term-memory, context-offloading, symbolic-memory, mermaid, local-first, vector-search, embedding, sqlite, sqlite-vec, bm25, rrf, openclaw, hermes-agent, tencentdb]
categories: [AI]
draft: false
source: "https://github.com/Tencent/TencentDB-Agent-Memory"
author: "Tencent"
---

# TencentDB Agent Memory

## 简介

TencentDB Agent Memory 是腾讯开源的 AI Agent 记忆系统，定位是为 Agent 提供“符号化短期记忆 + 分层式长期记忆”。

项目强调本地优先和可追溯：不是把历史对话粗暴堆进上下文，也不是做不可逆摘要，而是通过分层结构保留高层语义与底层证据之间的下钻链路。

官方描述：

> TencentDB Agent Memory delivers fully local long-term memory for AI Agents via a 4-tier progressive pipeline, with zero external API dependencies.

仓库地址：

https://github.com/Tencent/TencentDB-Agent-Memory

## 核心价值

### 1. 符号化短期记忆

长程 Agent 任务中，最容易撑爆上下文的是工具调用日志、搜索结果、代码片段、报错栈等中间信息。

TencentDB Agent Memory 的思路是：

- 将完整工具日志卸载到外部文件系统；
- 用 Mermaid 符号图谱表示任务状态与步骤关系；
- Agent 上下文中只保留高层任务画布；
- 需要细节时再通过 `node_id` 下钻到原始日志。

这类设计适合长任务、复杂调试、多轮工具调用、AI 编码 Agent 等场景。

### 2. 分层式长期记忆

项目把长期记忆组织成语义金字塔：

```text
L0 Conversation → L1 Atom → L2 Scenario → L3 Persona
```

含义：

- `L0 Conversation`：原始对话；
- `L1 Atom`：原子事实；
- `L2 Scenario`：场景块；
- `L3 Persona`：用户画像、偏好、长期习惯。

日常召回时优先使用高层 Persona / Scenario，需要精确依据时再下钻到底层 Atom / Conversation。

### 3. 渐进式披露与可恢复

项目的一个重点是避免“摘要后不可恢复”。

它保留从高层抽象到底层证据的链路：

```text
Persona / Mermaid Canvas
→ Scenario / JSONL
→ Conversation / refs/*.md
```

这样既能降低上下文压力，又能在需要验证时找回原始依据。

### 4. 白盒可调试

很多记忆系统的问题是：召回错了以后只能看到向量分数，很难判断问题出在哪。

TencentDB Agent Memory 将关键中间产物保存为可读文件，例如：

- Mermaid 任务画布；
- Markdown 场景块；
- persona.md；
- 原始 refs；
- JSONL 步骤摘要。

因此更适合人工检查、调试和修正。

## 效果数据

README 中给出的 OpenClaw 集成效果包括：

| 记忆能力 | Benchmark | 原始结果 | 接入后 | 变化 |
|---|---:|---:|---:|---:|
| 短期记忆 | WideSearch | 33% | 50% | +51.52% |
| 短期记忆 | SWE-bench | 58.4% | 64.2% | +9.93% |
| 短期记忆 | AA-LCR | 44.0% | 47.5% | +7.95% |
| 长期记忆 | PersonaMem | 48% | 76% | +59% |

Token 消耗方面，WideSearch 场景从 221.31M 降到 85.64M，最高节省 61.38%。

这些结果来自连续长程 Session，而不是每道题单独清空上下文的短任务测试。

## 技术关键词

- AI Agent Memory
- Long-term Memory
- Short-term Memory
- Context Offloading
- Mermaid Symbol Graph
- Local-first Memory
- SQLite + sqlite-vec
- BM25 + Vector + RRF Hybrid Retrieval
- Persona / Scenario / Atom
- OpenClaw Plugin
- Hermes Gateway Adapter

## 支持的集成

### OpenClaw

安装插件：

```bash
openclaw plugins install @tencentdb-agent-memory/memory-tencentdb
openclaw gateway restart
```

默认使用本地 SQLite + sqlite-vec 后端。

### Hermes Agent

README 中提供了基于 Docker 的 Hermes Gateway 启动方式，镜像内置 TencentDB Agent Memory 相关能力。

适合关注点：

- Hermes Gateway 适配层；
- 本地记忆后端；
- 长短期记忆结合；
- context offload；
- 与现有 Hermes memory / MemTensor 机制对比。

## 为什么值得关注

这个项目值得关注的地方不是“又一个向量记忆库”，而是它明确反对平铺式向量堆：

1. 记忆不是越多越好，而是要减少人重复说明；
2. 上下文压缩必须可追溯，不应丢失底层证据；
3. 长期记忆应该有层级，从原始对话到用户画像逐层沉淀；
4. 短期记忆应该能处理长任务中的工具日志爆炸；
5. Mermaid 任务画布是一种比较适合 Agent 解析和人类审查的中间表示。

## 可进一步研究的问题

- 与 Hermes 当前 MemTensor MCP bridge 的差异；
- 是否可以作为 Hermes 本地 memory backend 的补充；
- Mermaid canvas 对长程编码任务是否比普通摘要更稳定；
- L0→L3 的记忆生成质量如何评估；
- 自动 Skill generation 的 roadmap 是否能落地；
- 本地 SQLite + sqlite-vec 在大量长期记忆下的性能上限；
- BM25 + Vector + RRF 对中文工作流记忆召回是否足够好。

## 链接

- GitHub： https://github.com/Tencent/TencentDB-Agent-Memory
- Clone： `git clone https://github.com/Tencent/TencentDB-Agent-Memory.git`

## 备注

这类项目和长期使用 AI Coding Agent 的工作流高度相关，尤其适合结合以下场景观察：

- 多轮代码开发；
- 长任务上下文卸载；
- 用户偏好与项目规则沉淀；
- Agent 之间共享经验；
- 自动生成可复用 Skill / SOP。
