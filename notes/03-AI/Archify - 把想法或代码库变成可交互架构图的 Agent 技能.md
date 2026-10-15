---
title: Archify
date: 2026-10-15
slug: "archify---把想法或代码库变成可交互架构图的-agent-技能"
tags: [open-source, ai-agent, agent-skills, diagram, visualization, architecture-diagram, diagrams-as-code, claude-code, codex, developer-tools, trending]
categories: [AI]
draft: false
source: "https://github.com/tt-a1i/archify"
author: "tt-a1i"
---

## 简介

Archify 是一个 Agent 技能（skill），可以把任意想法、计划或代码库转成漂亮的**可交互 HTML 架构图**。适用于 Claude Code、Codex、Cursor、OpenCode 等编码 Agent。曾登上 GitHub Trending 周榜全语言第一，skills.sh 上安装量 13 万+。

## 核心特性

- **一句话出图**：无需仓库，直接描述系统（如 "Browser -> API -> Redis cache -> PostgreSQL fallback"）即可生成；也可以让 Agent 读取仓库，产出带源码证据的架构图（节点标注 `SRC n`，链接到固定 commit 的文件和行号）。
- **五种图类型**：Architecture（组件/服务/边界）、Workflow（CI/CD、审批流）、Sequence（API 调用时序）、Data Flow（数据管道、血缘、PII 边界）、Lifecycle（状态机、重试、终止态）。
- **类型化 JSON IR**：每种渲染模式都有 schema 和可复现的源文件，支持原子化校验（schema、布局、HTML/SVG、路径、标签避让全部通过才替换上一次良好输出）。
- **可迭代对话**：生成后继续说 "add Redis"、"highlight the rollback path"、"切换到浅色主题" 即可增量修改。
- **交互式查看器**：节点聚焦、上游/下游可达性追踪（Upstream/Downstream）、路径探测（`R`/`PATH`）、角色对比透镜（`L`）、总览雷达（`M`）、演示模式（`F`）。
- **导出与分享**：输出是单文件自包含 HTML，发出去交互还在；支持 PNG 剪贴板、静态/动图导出、1200×630 分享卡片（Route/Reach Share Card）。
- **诚实渲染**：不虚构拓扑、不声称运行时影响；不做自动布局堆砌，由 Agent 做布局判断（层级、间距、走线、强调）。
- **明确不做**：通用绘图编辑器、Mermaid 自动解析、托管分享、WYSIWYG 编辑。

## 安装与使用

```bash
npx skills add tt-a1i/archify -g
```

然后对 Agent 说：`Use Archify to draw: Browser -> API -> Redis cache -> PostgreSQL fallback.`

CLI 命令：`generate` / `validate --json` / `preview`（仅回环地址的实时预览循环）/ `deliver --open`（原子交付）/ `compare`（Architecture Delta：Before/Delta/After 对比，用于设计或 PR 评审）。

## 链接

- 仓库：https://github.com/tt-a1i/archify
- 在线示例画廊（Proof Lab，11 个已验证场景 + JSON 源）：https://tt-a1i.github.io/archify/gallery.html
- 场景指南：https://tt-a1i.github.io/archify/guide.html
- 中文 README：https://github.com/tt-a1i/archify/blob/main/README_ZH.md
