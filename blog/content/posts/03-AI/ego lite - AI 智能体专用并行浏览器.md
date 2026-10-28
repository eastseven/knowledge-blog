---
title: ego lite - AI 智能体专用并行浏览器
date: 2026-10-29
slug: "ego-lite---ai-智能体专用并行浏览器"
tags: [ai-agent, browser-automation, browser, agent-tools, codex, claude-code, web-automation, local-first, privacy, open-source, mit-license, developer-tools]
categories: [AI]
draft: false
source: "https://github.com/citrolabs/ego-lite"
author: "citrolabs"
---

## 简介

[ego lite](https://github.com/citrolabs/ego-lite) 是面向 AI 智能体的专用 Chromium 浏览器。它让用户与 Codex、Claude Code 等智能体在同一浏览器内并行工作：每个智能体任务运行在独立的 Space（隔离工作区）中，不会抢占用户正在使用的标签页或鼠标。

项目通过 `ego-browser` 将浏览器能力以 JavaScript API 形式提供给智能体，支持页面快照、导航、表单填写、点击、等待和截图等操作。浏览器可迁移既有 Chrome 数据，因此智能体可在本机受控地复用用户已有的登录状态、Cookie、扩展和书签。

## 核心特性

- **任务隔离与并行**：每个智能体或任务都有独立 Space，可同时执行多个浏览任务而互不干扰。
- **共享真实浏览器状态**：基于本机浏览器数据工作，减少重复登录、Cookie 丢失和独立自动化浏览器环境不稳定的问题。
- **面向智能体的 JavaScript 接口**：智能体可把多步网页操作组合为一次代码执行，减少工具往返和上下文消耗。
- **高质量页面快照**：为文本智能体提供结构化页面视图，重点改善复杂嵌套 iframe 的可操作性。
- **本地优先与免费使用**：项目强调浏览数据留在本机；仓库采用 MIT 许可证，浏览器作为免费独立下载提供。
- **跨智能体兼容**：可服务于 Codex、Claude Code、Cursor 和自定义智能体工作流。

## 链接

- GitHub：https://github.com/citrolabs/ego-lite
- 文档：https://lite.ego.app/document/
- 社区：https://discord.gg/ego-browser
