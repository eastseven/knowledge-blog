---
title: GStack
date: 2026-04-25
slug: gstack---claude-code-ai虚拟工程团队框架
tags: [open-source, ai-agent, ai-coding, claude-code, developer-tools, prompt-engineering, best-practices, multi-agent]
categories: [AI]
draft: false
source: https://github.com/garrytan/gstack
author: garrytan
---

## 简介

GStack 是 Y Combinator 总裁 Garry Tan 开源的 Claude Code 技能框架，将 Claude Code 变成一个虚拟工程团队。包含 23 个专业角色（CEO、设计师、工程经理、发布工程师、文档工程师、QA 等）和 8 个强力工具，全部通过斜杠命令调用，纯 Markdown 配置，MIT 协议免费使用。

项目已有 82K+ Stars，15K 安装量，305K 次调用，95.2% 成功率。

## 核心特性

- **模块化技能系统**：38+ 技能模板，YAML frontmatter 配置，通过斜杠命令或自然语言触发
- **Preamble 组合机制**：有序的解析器流水线组装 SKILL.md，包含混淆协议、模型覆盖层、跨机器记忆同步等
- **多主机支持**：10 个主机（Claude Code、Codex、OpenClaw、Hermes 等），每个主机有独立的工具重写和路径配置
- **模型覆盖层系统**：针对不同模型（Opus 4.7、Sonnet 4.6 等）的差异化行为调整，经过严格 A/B 测试验证
- **安全加固**：隧道双监听器架构、SSRF 防护、6 层侧边栏安全、ML Prompt 注入防御
- **跨机器记忆同步**（GBrain Sync）：在不同设备间同步上下文和记忆
- **Confusion Protocol**：高风险决策时的歧义检查门，防止错误假设
- **完善的测试基础设施**：774+ 测试用例，包含黄金夹具和门控层测试

## 链接

- GitHub: https://github.com/garrytan/gstack
