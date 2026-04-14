---
title: Multica
date: 2026-04-14
slug: multica---开源ai-agent管理平台
tags: [open-source, ai-agent, agent-platform, coding-agent, team-collaboration, multi-agent, self-hosted, go, nextjs]
categories: [AI]
draft: false
source: https://github.com/multica-ai/multica
author: multica-ai
---

## 简介

Multica 是一个开源的 AI 编码 Agent 管理平台，核心理念是"把 AI coding agent 变成真正的队友"。支持将 Claude Code、Codex、OpenClaw、OpenCode 等 agent 以看板方式管理，像分配任务给同事一样给 agent 派活——它们自主执行、汇报状态、积累可复用技能。

## 核心特性

- **Agent 生命周期管理**：任务分配 → 执行监控 → 技能复用，全流程自动化
- **看板式任务追踪**：Agent 出现在 Board 上，参与对话，更新状态
- **自动检测 Agent CLI**：daemon 自动发现本机已安装的 agent（claude、codex 等）
- **技能复用（Compound Skills）**：Agent 执行过的经验可沉淀为可复用技能
- **多 Agent 支持**：Claude Code、Codex、OpenClaw、OpenCode
- **自托管友好**：支持 Docker 部署完整服务端
- **厂商中立**：不绑定特定 AI provider

## 技术栈

- 前端：Next.js 16 (App Router)
- 后端：Go (Chi + sqlc + gorilla/websocket)
- 数据库：PostgreSQL 17 + pgvector
- 构建：pnpm workspaces + Turborepo

## 链接

- GitHub: https://github.com/multica-ai/multica
- 官网: https://multica.ai
- Cloud: https://multica.ai/app
