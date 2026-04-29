---
title: MemOS
date: 2026-04-29
slug: memos---ai-agent记忆操作系统
tags: [open-source, ai-memory, ai-agent, llm, memory-os, knowledge-base, multi-modal, personalization, mcp]
categories: [AI]
draft: false
source: https://github.com/MemTensor/MemOS
author: MemTensor
---

## 简介

MemOS 是一个面向 LLM 和 AI Agent 的记忆操作系统（Memory Operating System），统一了记忆的存储/检索/管理，支持长期记忆、知识库、多模态记忆、工具记忆等，实现上下文感知和个性化交互。当前版本 v2.0「星尘（Stardust）」，在多项基准测试中表现优异：LoCoMo 75.80、LongMemEval +40.43%、PrefEval-10 +2568%，相比 OpenAI Memory 准确率提升 43.70%，节省 35.24% 记忆 Token。

## 核心特性

- **统一记忆 API**：单一 API 实现记忆的增删改查，以图结构组织，可检视可编辑，非黑盒 embedding 存储
- **多模态记忆**：原生支持文本、图像、工具 trace、Persona，在同一记忆系统中联合检索和推理
- **多立方体知识库管理**：多个知识库作为可组合的 Memory Cube，支持隔离、受控共享、动态组合
- **异步调度（MemScheduler）**：毫秒级延迟的异步记忆操作，高并发下保持生产级稳定
- **记忆反馈与修正**：用自然语言反馈来纠正、补充或替换已有记忆
- **OpenClaw 插件**：支持云端和本地两种模式。云端模式降低 72% Token 用量、支持多 Agent 记忆共享；本地模式 100% 设备端运行，SQLite 持久化 + FTS5/向量混合搜索

## 技术架构

- 支持 LLM 后端：OpenAI、Azure OpenAI、Qwen（DashScope）、DeepSeek、MiniMax、Ollama、HuggingFace、vLLM
- 部署方式：Docker Compose 或 uvicorn CLI
- 依赖服务：Neo4j + Qdrant
- 许可证：Apache 2.0

## 链接

- GitHub: https://github.com/MemTensor/MemOS
- 文档: https://memos-open.readme.io
- 论文: https://arxiv.org/abs/2507.03724
