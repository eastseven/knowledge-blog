---
title: DESIGN.md
date: 2026-04-23
slug: design.md---google视觉身份描述规范
tags: [open-source, design-system, ai-agent, design-token, claude-code, cli, google, best-practices]
categories: [AI]
draft: false
source: https://github.com/google-labs-code/design.md
author: google-labs-code
---

## 简介

DESIGN.md 是 Google Labs 推出的一个格式规范，用于向 AI 编码 Agent 描述项目的视觉身份。通过 YAML front matter 定义机器可读的设计 token，配合 Markdown 正文说明设计理念，让 Agent 获得持久、结构化的设计系统理解。

## 核心特性

- **双层结构**：YAML front matter（设计 token）+ Markdown 正文（设计理念）
- **Token 类型**：颜色、排版、圆角、间距、组件
- **组件 Token**：支持 `button-primary` 等组件定义，支持 `{colors.primary}` 引用
- **CLI 工具**（`@google/design.md`）：
  - `lint` — 验证 DESIGN.md 结构正确性、WCAG 对比度、token 引用完整性
  - `diff` — 对比两个版本，检测 token 级别变更和回归
  - `export` — 导出为 Tailwind theme 或 DTCG (W3C Design Tokens) 格式
  - `spec` — 输出格式规范（可注入 Agent prompt）
- **7 条 Lint 规则**：broken-ref、missing-primary、contrast-ratio、orphaned-tokens、token-summary、missing-sections、missing-typography、section-order
- **设计理念段落**：Overview、Colors、Typography、Layout、Elevation & Depth、Shapes、Components、Do's and Don'ts

## 安装

```bash
npm install @google/design.md
# 或直接运行
npx @google/design.md lint DESIGN.md
```

## 链接

- GitHub: https://github.com/google-labs-code/design.md
- NPM: https://www.npmjs.com/package/@google/design.md
