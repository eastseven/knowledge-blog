---
title: CodeBurn
date: 2026-04-15
slug: codeburn---ai编程token成本可视化仪表盘
tags: [open-source, ai-agent, claude-code, coding-agent, token-cost, observability, tui, typescript, dev-tools]
categories: [AI]
draft: false
source: https://github.com/AgentSeal/codeburn
author: AgentSeal
---

## 简介

CodeBurn 是一个交互式 TUI 仪表盘，用于分析 Claude Code / Codex / Cursor 的会话记录，提供详细的 token 消耗和成本拆解。直接读取磁盘上的会话数据，无需代理、包装器或 API Key。

## 核心特性

- **多 IDE 支持**：Claude Code（`~/.claude/projects/`）、Claude Desktop（code tab）、Cursor IDE
- **13 类任务分类**：基于工具使用模式和关键词的确定性分类（Coding、Debugging、Feature Dev、Refactoring、Testing、Exploration 等），不调用 LLM
- **多维度拆解**：按日、项目、模型（Opus/Sonnet/Haiku/GPT-4o/Gemini）、活动类型、核心工具、MCP 服务器分解成本
- **定价数据**：从 LiteLLM 自动获取（24h 缓存），覆盖 input/output/cache write/cache read/web search 成本
- **macOS 菜单栏小组件**：支持 SwiftBar/xbar，显示今日花费火焰图标，5 分钟刷新
- **导出**：支持 CSV 和 JSON 格式导出

## 安装与使用

```shell
npm install -g codeburn
codeburn              # 交互式仪表盘（默认7天）
codeburn today        # 今日用量
codeburn month        # 本月用量
codeburn status       # 紧凑一行输出
codeburn export       # CSV 导出
```

## 链接

- GitHub: https://github.com/AgentSeal/codeburn
- 许可证: MIT
