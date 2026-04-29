---
title: Symphony - OpenAI自主Agent任务编排系统
date: 2026-04-30
slug: symphony---openai自主agent任务编排系统
tags: [open-source, ai-agent, coding-agent, autonomous-agent, orchestration, linear-integration, harness-engineering, elixir]
categories: [AI]
draft: false
source: https://github.com/openai/symphony
author: openai
---

## 简介

OpenAI Symphony 是一个将项目工作转化为隔离、自主的执行运行（implementation runs）的系统，让团队管理任务而非监督编码 Agent。目前定位为工程预览版（engineering preview），适合在可信环境中测试。

## 核心特性

- **Linear 集成**：监控 Linear 看板，自动识别待处理任务，为每个任务生成独立的 Codex Agent 执行环境
- **自主执行**：Agent 独立完成任务后提交 PR，并提供 proof of work：
  - CI 状态
  - PR review 反馈
  - 复杂度分析
  - 演示视频（walkthrough videos）
- **安全着陆**：任务被接受后，Agent 安全地合并 PR
- **Harness Engineering 范式**：倡导「管理 Agent 而非监督 Agent」的工程方法论
- **语言无关**：提供完整 SPEC.md 规范，可用任何语言实现；参考实现为 Elixir

## 技术栈

- Elixir (95.4%) + Python (3.0%) + CSS (1.3%)
- Apache 2.0 开源协议
- 15.5k Stars, 1.3k Forks

## 链接

- GitHub: https://github.com/openai/symphony
- 规范文档: https://github.com/openai/symphony/blob/main/SPEC.md
- Harness Engineering: https://openai.com/index/harness-engineering/
