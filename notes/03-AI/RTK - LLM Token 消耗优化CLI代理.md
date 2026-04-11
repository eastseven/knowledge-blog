---
title: RTK - Rust Token Killer
date: 2026-04-11
slug: rtk---llm-token-消耗优化cli代理
tags: [open-source, llm, token-optimization, cli, rust, ai-agent, developer-tools, claude-code, copilot, cursor, codex, devops]
categories: [AI]
draft: false
source: https://github.com/rtk-ai/rtk
author: rtk-ai / aeppling
---

## 简介

RTK（Rust Token Killer）是一个高性能 CLI 代理，在命令输出到达 LLM 上下文之前进行过滤和压缩，可将 token 消耗降低 60-90%。单个 Rust 二进制文件，零依赖，100+ 支持命令，开销 <10ms。

## 核心特性

- **大幅降低 token 消耗**：30 分钟 Claude Code 会话中，从约 118,000 tokens 降至约 23,900 tokens（节省 80%）
- **四大压缩策略**：智能过滤（去噪）、分组聚合、截断保留、去重折叠
- **100+ 命令支持**：git、gh、cargo、npm/pytest/go test、docker、kubectl、aws、eslint/ruff 等
- **自动改写 Hook**：透明拦截 Bash 命令（如 `git status` -> `rtk git status`），AI 工具无感知
- **10 种 AI 编码工具集成**：Claude Code、Copilot、Cursor、Gemini CLI、Codex、Windsurf、Cline、OpenCode、OpenClaw、Mistral Vibe（计划中）
- **Homebrew 安装**：`brew install rtk`，一行命令搞定
- **Tee 恢复机制**：命令失败时自动保存完整原始输出，无需重新执行

## 适用场景

使用 AI 编码代理（Claude Code、Copilot 等）开发项目时，通过压缩终端输出大幅减少 LLM token 消耗，节省 API 成本、提升响应速度。特别适合中大型项目的日常开发会话。

## 链接

- GitHub: https://github.com/rtk-ai/rtk
- 官网: https://www.rtk-ai.app
- Discord: https://discord.gg/RySmvNF5kF
