---
title: 驾驭工程：在「智能体优先」的世界里借力 Codex
date: 2026-04-10
slug: 驾驭工程---智能体优先世界的codex实践
tags: [article, ai-agent, codex, llm-coding, engineering, agent-first, best-practices, context-engineering]
categories: [AI]
draft: false
source: https://openai.com/index/harness-engineering/
author: Ryan Lopopolo
---

# 驾驭工程：在「智能体优先」的世界里借力 Codex

## 简介

原文作者 Ryan Lopopolo（OpenAI），记述了团队用 Codex（GPT-5 驱动）从零构建一款百万行代码产品的实验：**0 行代码由人工编写**，3 名工程师 5 个月处理 1500+ PR，效率约为手工编码的 10 倍。

> 人类掌舵，智能体执行。

## 核心经验

### 1. 从空仓库开始

- 最初的脚手架（仓库结构、CI、格式化、AGENTS.md）全部由 Codex 生成
- 5 个月后积累约百万行代码，3 名工程师日均处理 3.5 个 PR
- 核心信条：绝不手动写代码

### 2. 重新定义工程师角色

- 工程师不再是写代码，而是**设计环境、明确意图、建立反馈循环**
- 深度优先策略：把大目标拆为更小的积木，通过 Prompt 引导智能体构建
- 任务失败时不是"再试一次"，而是反问："缺少什么能力？如何让它对智能体可读又可执行？"
- 大部分代码评审由"智能体对智能体"互评完成

### 3. 提升应用的"可读性"

- 让 UI、日志、指标能被 Codex 直接"读懂"
- 每个 Git Worktree 独立启动应用实例，Codex 可驱动完整实例
- Chrome DevTools 协议接入智能体运行时 → 可重现 Bug、验证修复
- 本地可观测性栈暴露给 Codex，可用 LogQL/PromQL 查询
- 单次 Codex 运行可持续处理任务 6+ 小时（通常在人类睡觉时）

### 4. 上下文工程：给地图，不给说明书

- AGENTS.md 很短（约 100 行），充当目录而非百科全书
- 仓库知识库存在于结构化的 `docs/` 目录中，作为"单一事实来源"
- 渐进式披露：智能体从小的稳定入口点开始，被教导下一步去哪里看
- 机械化强制：Linter 和 CI 验证知识库是否最新、交叉链接是否正确
- "文档园丁"智能体定期扫描并修复过时文档

### 5. 强制架构与"品味"

- 通过强制执行不变性，而非微观管理实现细节
- 严格分层架构：Types → Config → Repo → Service → Runtime → UI
- 自定义 Linter 机械化强制约束，报错信息直接包含修复指令
- "黄金原则"编码进仓库，后台 Codex 任务定期扫描偏差并开启重构 PR
- 像垃圾回收一样：持续小额偿还技术债 > 让它利滚利

### 6. Bug 修复自动化流程

智能体可自主完成完整循环：重现 Bug → 录制故障视频 → 实施修复 → 验证修复 → 录制修复视频 → 开 PR → 响应反馈 → 修复构建失败 → 合并。

## 关键洞见

- 凡是智能体无法从运行时上下文获取的信息，对它来说就不存在
- 存在 Slack、Google Docs 或人脑中的知识 = 对智能体不可见
- 构建 AI 友好的代码库和构建新人友好的代码库本质相同
- 纪律不再体现在代码本身，更多体现在"脚手架"

## 链接

- 原文: https://openai.com/index/harness-engineering/
- 译文: https://baoyu.io/translations/2026-02-12/harness-engineering
