---
title: GitNexus
date: 2026-04-10
slug: gitnexus---零服务端代码智能引擎
tags: [open-source, code-intelligence, knowledge-graph, mcp, cli-tool, ai-agent, developer-tools]
categories: [AI]
draft: false
source: https://github.com/abhigyanpatwari/GitNexus
author: abhigyanpatwari
---

# GitNexus - 零服务端代码智能引擎

## 简介

GitNexus 是一个客户端代码知识图谱生成器，完全在浏览器或本地运行。丢入一个 GitHub 仓库或 ZIP 文件，即可生成交互式知识图谱，并内置 Graph RAG Agent。

核心理念：为 AI Agent 构建"神经系统"，让它们对代码库有深层架构认知，不再遗漏依赖、破坏调用链。

> Like DeepWiki, but deeper. DeepWiki 帮你理解代码，GitNexus 帮你分析代码。

## 两种使用方式

| 维度 | CLI + MCP | Web UI |
|------|-----------|--------|
| 用途 | 本地索引仓库，通过 MCP 连接 AI Agent | 浏览器中可视化图谱 + AI 对话 |
| 适用 | 日常开发（Cursor、Claude Code、Codex） | 快速探索、演示、一次性分析 |
| 存储 | LadybugDB 原生（快速持久化） | LadybugDB WASM（内存中） |
| 隐私 | 全部本地，无网络 | 全部浏览器内，无服务器 |

Bridge 模式：`gitnexus serve` 连接两者 — Web UI 自动检测本地服务，无需重复上传/索引。

## 核心功能

- **代码索引** — 将任意代码库索引为知识图谱：依赖关系、调用链、集群、执行流
- **MCP Server** — 为 AI Agent（Cursor、Claude Code、Codex、Windsurf）提供深层代码感知
- **Graph RAG Agent** — 内置图谱 RAG，让 AI 问答更精准
- **自动生成上下文** — 一条命令生成 AGENTS.md / CLAUDE.md 上下文文件
- **多编辑器支持** — Claude Code（完整）、Cursor（MCP+Skills）、Codex（MCP+Skills）、Windsurf、OpenCode
- **Code Wiki** — 自动生成且保持更新的代码文档

## 快速开始

```bash
# 索引仓库（从仓库根目录运行）
npx gitnexus analyze

# 配置 MCP（只需运行一次）
npx gitnexus setup
```

## 企业版

提供 SaaS 和自托管部署，额外包含：PR Review（爆炸半径分析）、自动重索引、多仓库统一图谱、优先语言/功能支持等。

## 链接

- GitHub: https://github.com/abhigyanpatwari/GitNexus
- Web UI: https://gitnexus.vercel.app
- Enterprise: https://akonlabs.com
