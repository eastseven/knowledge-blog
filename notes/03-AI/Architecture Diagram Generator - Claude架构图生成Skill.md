---
title: Architecture Diagram Generator
date: 2026-04-15
slug: architecture-diagram-generator---claude架构图生成skill
tags: [open-source, ai-agent, claude, claude-skill, architecture-diagram, visualization, svg, dev-tools, system-design]
categories: [AI]
draft: false
source: https://github.com/Cocoon-AI/architecture-diagram-generator
author: Cocoon-AI
---

## 简介

Architecture Diagram Generator 是一个 Claude AI Skill，能用自然语言描述生成专业深色主题的系统架构图，输出为独立的 HTML/SVG 文件，无需任何依赖。

## 核心特性

- **自然语言驱动**：用纯文本描述系统架构，自动生成可视化图表
- **深色主题**：Slate-950 背景 + 40px 网格，专业美观
- **语义色彩编码**：Frontend（青色）、Backend（绿色）、Database（紫色）、Cloud（琥珀色）、Security（玫瑰色）、External（灰色）
- **独立输出**：单 HTML 文件，内嵌 CSS + SVG，任何浏览器直接打开
- **多种安装方式**：claude.ai Skills、Claude Code CLI（`~/.claude/skills/`）、Projects Knowledge

## 使用方式

1. 安装 Skill（下载 zip 上传到 claude.ai Settings → Skills）
2. 描述架构（让 AI 分析代码库、手写描述、或让 Claude 生成典型架构）
3. 生成图表，支持迭代修改组件、布局

适用于 Claude Pro/Max/Team/Enterprise 计划。

## 链接

- GitHub: https://github.com/Cocoon-AI/architecture-diagram-generator
- 许可证: MIT
