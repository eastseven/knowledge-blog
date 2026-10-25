---
title: Langfuse - 开源 LLM 可观测性与评估平台
date: 2026-10-25
slug: "langfuse---开源-llm-可观测性与评估平台"
tags: [ai, llm, llmops, ai-observability, agent-evaluation, prompt-management, tracing, evaluation, self-hosted, open-source, developer-tools, typescript, python]
categories: [AI]
draft: false
source: "https://github.com/langfuse/langfuse"
author: "langfuse"
---

## 简介

Langfuse 是面向 LLM 应用与智能体的开源工程平台，统一提供调用链路追踪、调试、提示词管理、评估和数据集能力。它适合把模型调用、RAG、Embedding 与 Agent 工具调用串成可检索的全链路记录，并基于真实运行数据持续改进应用。

项目支持 Langfuse Cloud，也支持以 Docker Compose、虚拟机、Kubernetes Helm 或 Terraform 模板自托管。开源部分采用 MIT 许可，企业功能位于 `ee` 目录并有例外许可。

## 核心特性

- **LLM 可观测性**：采集 LLM 调用、检索、Embedding、Agent 动作等 Trace，按会话查看复杂执行链路并定位异常结果。
- **提示词管理**：集中保存、版本化和协作迭代 Prompt；服务端与客户端缓存可降低更新 Prompt 带来的额外延迟。
- **评估体系**：支持 LLM-as-a-Judge、代码评估器、用户反馈、人工标注，以及通过 API/SDK 接入自定义评估流水线。
- **数据集与实验**：构建测试集和基准，支持部署前验证、持续评估与结构化实验。
- **LLM Playground**：在发现不佳 Trace 后，可直接带入 Playground 调整 Prompt 与模型配置，缩短调试闭环。
- **生态集成**：提供 Python、JavaScript/TypeScript SDK 和 OpenAPI；支持 OpenAI、LangChain、LlamaIndex、Haystack、LiteLLM、Vercel AI SDK、DSPy、CrewAI 等。
- **生产部署**：生产场景推荐 Kubernetes + Helm；底层使用 ClickHouse，并提供 Docker Compose 快速本地启动方案。

## 适用场景

- 为 AI 应用、RAG 与多智能体系统建立统一调用审计与故障定位能力。
- 将 Prompt、离线测试集、线上用户反馈和自动评估纳入同一持续改进流程。
- 私有化部署 LLMOps 可观测性平台，保留调用数据与评估数据的控制权。

## 链接

- GitHub：https://github.com/langfuse/langfuse
- 官方文档：https://langfuse.com/docs
- 在线演示：https://langfuse.com/project/example
