---
title: Open Design
date: 2026-04-29
slug: open-design---claude-design开源替代设计工具
tags: [open-source, ai-design, ai-agent, design-system, coding-agent, claude-code, ui-design, prototype, local-first, byok]
categories: [AI]
draft: false
source: https://github.com/nexu-io/open-design
author: nexu-io
---

## 简介

Open Design 是 Anthropic Claude Design 的开源替代方案。本地优先、可部署到 Vercel、全链路 BYOK（Bring Your Own Key）。核心理念：不内置 Agent，而是复用你已有的编码 Agent（Claude Code、Codex CLI、Cursor Agent、Gemini CLI、OpenCode、Qwen Code）作为设计引擎，通过 19 个可组合 Skills 和 71 个品牌级 Design Systems 驱动设计工作流。

## 核心特性

- **19 个设计 Skills**：覆盖 prototype、deck、mobile、dashboard、pricing、docs、blog、SaaS landing 等场景，另有 10 个文档模板（PM spec、weekly update、OKRs、runbook 等）
- **71 个品牌级 Design Systems**：Linear、Stripe、Vercel、Airbnb、Tesla、Notion、Apple、Cursor、Supabase、Figma 等知名品牌设计系统，采用 9-section DESIGN.md 标准格式
- **5 种视觉方向**：Editorial Monocle、Modern Minimal、Tech Utility、Brutalist、Soft Warm，每种自带确定性 OKLch 色板 + 字体栈
- **设备框架**：iPhone 15 Pro、Pixel、iPad Pro、MacBook、Browser Chrome，像素级精确
- **Anti-AI-slop 机制**：问题表单优先、品牌色提取协议、五维自评（philosophy/hierarchy/execution/specificity/restraint）、P0/P1/P2 检查清单、设计黑名单
- **导出格式**：HTML、PDF、PPTX、ZIP、Markdown

## 架构

- 前端：Vite 5 + React 18 + TypeScript
- 守护进程：Node 18+ / Express / SSE 流式 / better-sqlite3
- Agent 传输：child_process.spawn，Claude Code 用 stream-json，其他 CLI 用行缓冲
- 预览：沙箱 iframe（srcdoc）+ per-skill artifact 解析器
- 存储：`.od/` 本地目录 + SQLite

## 技术栈

本地运行 `pnpm dev:all` 即可（daemon :7456 + Vite :5173），也可部署到 Vercel。Apache-2.0 开源协议。

## 链接

- GitHub: https://github.com/nexu-io/open-design
