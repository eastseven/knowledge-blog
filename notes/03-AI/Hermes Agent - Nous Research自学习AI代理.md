---
title: Hermes Agent
date: 2026-04-11
slug: hermes-agent---nous-research自学习ai代理
tags: [open-source, ai-agent, hermes, nous-research, llm-agent, self-improving, cli-tool, messaging-gateway, skill-system]
categories: [AI]
draft: false
source: https://github.com/nousresearch/hermes-agent
author: NousResearch
---

## 简介

Hermes Agent 是 Nous Research 开发的自学习 AI 代理，口号是 "The agent that grows with you"。最大特点是内置闭环学习：从经验中创建技能、使用中自我改进、主动持久化知识、搜索历史对话、跨会话构建用户模型。

## 核心特性

**真实终端界面**：完整 TUI，支持多行编辑、斜杠命令自动补全、会话历史、中断重定向、流式工具输出。

**全平台接入**：Telegram、Discord、Slack、WhatsApp、Signal、CLI —— 单一网关进程统一管理，支持语音备忘录转写、跨平台会话连续。

**闭环学习系统**：
- Agent 策划的记忆 + 周期性提醒
- 复杂任务后自动创建技能，使用中自我改进
- FTS5 会话搜索 + LLM 摘要实现跨会话回忆
- Honcho 方言式用户建模
- 兼容 agentskills.io 开放标准

**模型自由**：支持 Nous Portal、OpenRouter（200+ 模型）、z.ai/GLM、Kimi/Moonshot、MiniMax、OpenAI 或自定义端点，一条命令切换。

**定时自动化**：内置 cron 调度器，可投递到任意平台——日报、夜间备份、周审计，自然语言描述即可。

**委托与并行**：生成隔离子代理处理并行工作流，Python 脚本通过 RPC 调用工具，多步管道压缩为零上下文开销。

**随处运行**：六种终端后端——local、Docker、SSH、Daytona、Singularity、Modal。Daytona/Modal 提供无服务器持久化，空闲时休眠、按需唤醒，成本极低。

**研究就绪**：批量轨迹生成、Atropos RL 环境、轨迹压缩，用于训练下一代工具调用模型。

## 链接

- GitHub: https://github.com/nousresearch/hermes-agent
- 文档: https://hermes-agent.nousresearch.com/docs
