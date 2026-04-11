---
title: Graphify
date: 2026-04-11
slug: graphify---ai代码知识图谱生成工具
tags: [open-source, ai-agent, knowledge-graph, claude-code, code-analysis, multimodal, developer-tools, tree-sitter, python]
categories: [AI]
draft: false
source: https://github.com/safishamsi/graphify
author: safishamsi
---

## 简介

Graphify 是一个 Claude Code 技能，输入 `/graphify` 即可读取文件并构建知识图谱。支持代码、PDF、Markdown、截图、图表、白板照片甚至其他语言的图片 -- 使用 Claude 视觉从所有内容中提取概念和关系，连接成一张图。

## 核心特性

- **多模态输入**：代码（tree-sitter AST）、文档、PDF、图片（Claude vision 提取）
- **大幅减少 token**：52 文件混合语料上，查询 token 减少 71.5 倍
- **多种输出格式**：交互式 HTML 图谱、Obsidian vault、Wiki 风格文章、SVG、GraphML、Neo4j Cypher
- **持久化与增量更新**：SHA256 缓存，只处理变更文件；`--watch` 模式自动同步
- **图查询能力**：`graphify query`、`graphify path`、`graphify explain`
- **Git hook 集成**：`graphify hook install` 每次提交自动重建图谱
- **多平台支持**：Claude Code、Codex、OpenCode、Cursor、Gemini CLI、OpenClaw、Factory Droid、Trae
- **技术栈**：NetworkX + Leiden（graspologic）+ tree-sitter + Claude + vis.js，完全本地运行

## 适用场景

将代码库、研究论文、笔记、截图等混合语料转化为可查询的知识图谱。特别适合 AI 代理跨会话理解大型项目，解决 Karpathy 式的 `/raw` 文件夹问题。

## 链接

- GitHub: https://github.com/safishamsi/graphify
