---
title: Kami
date: 2026-04-22
slug: kami---ai-文档设计系统
tags: [open-source, ai-agent, document-design, design-system, typography, claude-code, codex, pdf-generation, best-practices, chinese]
categories: [AI]
draft: false
source: https://github.com/tw93/kami
author: tw93
---

# 简介

Kami（紙，かみ）是 tw93（大漠穷秋）开源的 AI 文档设计系统，核心理念是"好内容值得好纸张"。它不是 UI 框架，而是一套美学约束系统，让 AI Agent 生成排版精美的文档（HTML/PDF），告别千篇一律的默认样式。

与 Kaku（代码）和 Waza（习惯）同属一个工具家族。

# 核心特性

- 统一视觉语言：暖色羊皮纸底色 `#f5f4ed` + 墨蓝强调色 `#1B365D`，拒绝冷灰和渐变
- 严格排版约束：衬线字重锁定 500、行高精确分区、温暖色调中性色
- 6 种文档类型：One-Pager、Slides、Resume、Portfolio、Long Doc、Letter，每种支持中英双语
- 内置 3 种 SVG 图表：架构图、流程图、象限图
- 支持 Claude Code、Codex 内置集成，也可用于其他 AI Agent（opencode、pi 等）
- 自然语言触发，无需斜杠命令

# 设计规格要点

- 字体：中文（仓耳今楷02 + 思源黑体）、英文（Newsreader + Inter）
- 衬线字重仅用 500，不使用粗体
- 行高严格分段：标题 1.1-1.3、密集正文 1.4-1.45、阅读正文 1.5-1.55
- 阴影仅用 ring/whisper，无硬阴影
- 标签用实色背景，避免 rgba 触发 WeasyPrint bug

# 适用场景

创业公司介绍、个人简历、项目作品集、演讲幻灯片、白皮书、推荐信等需要高质量排版输出的文档。

# 链接

- GitHub: https://github.com/tw93/kami
- 在线预览: https://kami.tw93.fun
