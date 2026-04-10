---
title: 2026年AI编码的"渐进式Spec"实战指南
date: 2026-04-10
slug: 2026年ai编码的渐进式spec实战指南
tags: [article, ai-coding, spec-coding, agent, engineering, llm-coding, methodology, best-practices, chinese]
categories: [AI]
draft: false
source: https://mp.weixin.qq.com/s/7Lgb3GfgXKI0J9L9e9sq0w
author: 逸驹
---

# 2026年AI编码的"渐进式Spec"实战指南

## 简介

来自阿里工程师逸驹的实战分享，提出"渐进式 Spec Coding"框架——在让 AI 写代码之前，先用结构化文档（Spec）把"要做什么、怎么做、有什么约束"说清楚，然后 AI 围绕文档编码。核心思想：不同复杂度的需求，暴露不同深度的流程。

## 三个基础认知

### 1. 如何理解大模型
- 当前顶级模型可独立完成中等复杂度编码任务，但仍需人审查
- 模型梯队差异是断崖式的：T0 三轮搞定的事，T2 可能 15 轮还不对
- 核心结论：模型是地基，方法论是上层建筑

### 2. 如何理解 Agent
- Agent = while 循环 + Tool Use + 工具执行器
- 工具的边界就是 Agent 的能力边界
- Cursor、Claude Code、opencode 本质上都是这个循环的不同包装

### 3. 回归本质：软件复杂度视角
- 软件复杂度 = 本质复杂度 + 偶然复杂度
- AI 能帮你更高效应对本质复杂度，但工具自身也会引入偶然复杂度
- 评判标准：高效应对本质复杂度，同时压缩偶然复杂度

## Spec Coding 三条铁律

1. **No Spec, No Code** — 没有文档，不准写代码
2. **Spec is Truth** — 文档和代码冲突时，错的一定是代码
3. **Reverse Sync** — 发现 Bug，先修文档，再修代码

## 核心设计：渐进式复杂度

70% 的需求是 ≤5 人日的小需求，不应强制走完整流程：
- **简单需求**：只加载 Rules，直接编码
- **中等需求**：Rules + 轻量 Spec
- **复杂需求**：Rules + 完整 Spec + Tasks + Review

> 简单需求不承担复杂流程的成本——改个字段不需要先写 spec 再拆 tasks

## 工作流：Propose → Apply → Review → Archive

- **Propose（提案）**：人主导，AI 辅助。Research → 逐个提问 → 分段生成文档 → 确认门控
- **Apply（执行）**：AI 主导，人审查。逐步执行，零偏差原则，必须展示可验证证据
- **Fix（修正）**：Review 后的增量修正，文档同步是铁律
- **Review（审查）**：两阶段 Sub Agent 审查（Spec 合规 + 代码质量），上下文与实现者隔离
- **Archive（归档）**：知识沉淀到 knowledge/，变更目录归档

## 编排层 + 执行层两层架构

| 层 | 职责 | 模型选择 |
|---|---|---|
| 编排层 | 理解需求、生成 Spec、审查决策 | 强模型（Claude Opus、Gemini Pro） |
| 执行层 | 读写代码、执行命令、快速迭代 | 编码优化模型（Sonnet、Kimi） |

## 关键观点

### 人到底该干什么？
- 传统编程：人 = 设计者 + 实施者 + 验收者
- AI 编程：人 = 设计者 + 验收者，AI = 实施者
- 自由度曲线：调研（中）→ 方案设计（高）→ 规划（低）→ 执行（零）→ 验收（中）
- 大部分人的问题是自由度给反了

### 知识底座才是真正的护城河
- 最关键的领域 Know-How、架构决策前因后果，恰恰是 Spec 框架最难覆盖的
- 没有 knowledge/ 的 Spec 框架 = 让应届生对着编码规范写代码
- 工具会趋同，领域知识才是不可复制的护城河

### 容易忽略的代价
- **心流中断**：从连续流变成间歇流
- **上下文隐性成本**：每次压缩都引入不确定性
- **现在不是终态**：框架价值随模型进步放大收益

## 参考资料

- Superpowers agentic skills 框架: https://github.com/obra/superpowers
- Simon Willison - Agentic Engineering Patterns
- Chatbot Arena Leaderboard: https://arena.ai/

## 链接

- 原文: https://mp.weixin.qq.com/s/7Lgb3GfgXKI0J9L9e9sq0w
