---
title: Claude Code Best Practices
date: 2026-04-10
slug: claude-code-best-practices---claude-code最佳实践指南
tags: [open-source, claude-code, ai-agent, best-practices, ai-coding, prompt-engineering, study-material, agentic-engineering]
categories: [AI]
draft: false
source: https://github.com/shanraisshan/claude-code-best-practice
author: shanraisshan
---

## 简介

Claude Code 最佳实践合集，口号是 "from vibe coding to agentic engineering"。由 shanraisshan 维护，Anthropic Claude Code 创造者 Boris Cherny 等人贡献内容，是目前最全面的 Claude Code 使用指南。

## 核心内容

**Concepts 概念体系**：涵盖 Agents（自治子代理）、Commands（命令模板）、Skills（可复用技能）、Hooks（事件钩子）、MCP Servers、Plugins、Memory（CLAUDE.md）等核心概念的定位与用法对比。

**69 条 Tips & Tricks**，按类别组织：
- **Prompting**：挑战 Claude 验证结果，别微观管理，让 Claude 自己修 bug
- **CLAUDE.md**：每文件控制在 200 行以内，用 `<important if="...">` 标签防止被忽略，用 rules/ 拆分大指令
- **Agents**：用子代理分担计算、agent teams + git worktrees 并行开发
- **Skills**：用 context: fork 隔离运行、description 写触发条件而非摘要、建 Gotchas 段记录失败点
- **Hooks**：用 PreToolUse 测量技能使用率、PostToolUse 自动格式化、Stop hook 督促继续
- **Workflows**：50% 时手动 /compact、Opus 做规划 Sonnet 写代码、/rewind 回退而非修修补补
- **Debugging**：截图分享、MCP 看浏览器控制台、后台任务看日志、agentic search > RAG

**开发工作流对比**：收录了 Everything Claude Code、Superpowers、Spec Kit、gstack、GSD、BMAD-METHOD 等 10+ 工作流的 Plan/Agent/Skill 架构对比分析。

**视频/播客资源**：Boris Cherny 在 YC、Lenny's Podcast、Pragmatic Engineer 等频道的深度访谈。

## 链接

- GitHub: https://github.com/shanraisshan/claude-code-best-practice
