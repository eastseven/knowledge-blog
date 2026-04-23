---
title: Fireworks Tech Graph
date: 2026-04-23
slug: fireworks-tech-graph---ai技术图表生成技能
tags: [open-source, claude-code, ai-diagram, svg, technical-diagram, ai-agent, visualization, uml]
categories: [AI]
draft: false
source: https://github.com/yizhiyanhua-ai/fireworks-tech-graph
author: yizhiyanhua-ai
---

## 简介

Fireworks Tech Graph 是一个 Claude Code 技能，用于从自然语言描述生成生产级 SVG+PNG 技术图表。支持 8 种图表类型、7 种视觉风格，内置 AI/Agent 领域知识（RAG、Agentic Search、Mem0、Multi-Agent、Tool Call 等），覆盖全部 14 种 UML 图表类型。

## 核心特性

- **7 种视觉风格**：Flat Icon、Dark Terminal、Blueprint、Notion Clean、Glassmorphism、Claude Official、OpenAI Official
- **8+ 图表类型**：架构图、数据流图、流程图、Agent 架构图、内存架构图、序列图、对比矩阵、思维导图等
- **AI/Agent 领域模式**：内置 RAG Pipeline、Agentic Search、Mem0、Multi-Agent、Tool Call Flow 等模式
- **语义形状词汇**：LLM=双线圆角矩形、Agent=六边形、Vector Store=环形圆柱等
- **语义箭头系统**：颜色+虚线编码含义（读/写/异步/循环）
- **40+ 产品图标**：OpenAI、Anthropic、Pinecone、Kafka、PostgreSQL 等
- **10 步工作流**：分类→提取结构→规划布局→加载风格→映射节点→检查图标→写SVG→验证→导出PNG→报告

## 安装

```bash
npx skills add yizhiyanhua-ai/fireworks-tech-graph
# 依赖
brew install librsvg  # macOS
```

## 链接

- GitHub: https://github.com/yizhiyanhua-ai/fireworks-tech-graph
- NPM: https://www.npmjs.com/package/@yizhiyanhua-ai/fireworks-tech-graph
