---
title: Understand Anything
date: 2026-05-25
slug: "understand-anything---交互式代码知识图谱与项目理解工具"
tags: [open-source, github, ai, ai-agent, code-intelligence, codebase-analysis, knowledge-graph, architecture-analysis, developer-tools, onboarding, claude-code, codex, cursor, copilot, gemini-cli, hermes, llm-wiki, documentation, productivity, study-material]
categories: [AI]
draft: false
source: "https://github.com/Lum1104/Understand-Anything"
author: "Lum1104"
---

# Understand Anything

## 简介

Understand Anything 是一个面向代码库、知识库和文档的交互式知识图谱工具。它可以把项目中的文件、函数、类、依赖关系、架构层次和业务流程抽取成可探索、可搜索、可提问的图谱，帮助开发者从“逐文件阅读代码”转向“先理解整体结构”。

项目的核心定位不是生成一张复杂炫目的图，而是生成一张能教学、能导航、能解释系统如何组合运作的图。

GitHub: https://github.com/Lum1104/Understand-Anything

## 适用场景

- 新成员接手大型代码库时快速建立全局认知。
- 在重构或提交前分析改动影响范围。
- 为团队生成可共享的项目知识图谱和架构导览。
- 将 Karpathy-pattern LLM Wiki 一类知识库转换为可导航的知识图谱。
- 在 Claude Code、Codex、Cursor、Copilot、Gemini CLI、Hermes 等 AI 编程环境中增强项目理解能力。

## 核心能力

### 1. 结构化代码图谱

`/understand` 会扫描项目，抽取文件、函数、类、导入导出、调用关系等结构信息，并生成 `.understand-anything/knowledge-graph.json`。随后可以通过仪表盘以知识图谱形式浏览代码库。

节点支持：

- 文件、函数、类等代码实体；
- 架构层分类，例如 API、Service、Data、UI、Utility；
- 依赖关系、调用关系、导入导出关系；
- 面向自然语言的解释和摘要。

### 2. 交互式 Dashboard

通过 `/understand-dashboard` 打开可视化仪表盘：

- 支持平移、缩放、点击节点；
- 支持按名称或语义搜索；
- 点击节点后查看代码、关系和自然语言解释；
- 使用颜色和图例展示架构层次；
- 可按不同用户画像调整信息密度。

### 3. Guided Tours 架构导览

系统可以根据依赖关系自动生成学习顺序，帮助用户按更合理的路径理解项目，而不是随机阅读文件。

这对新成员 onboarding、项目交接、复杂系统理解尤其有价值。

### 4. 语义搜索与模糊搜索

除了按名称查找，也可以用自然语言搜索，例如：

- “哪些部分处理认证？”
- “支付流程在哪里？”
- “这个模块的入口是什么？”

这类搜索适合在大型代码库中快速定位功能点。

### 5. Diff Impact Analysis

`/understand-diff` 可以分析当前改动可能影响哪些模块，帮助在提交前理解变更的涟漪效应。

这类能力适合用于：

- PR review 前自查；
- 重构影响分析；
- 风险评估；
- 识别需要补充测试的区域。

### 6. 业务域视图

`/understand-domain` 可以从代码中提取业务域、业务流程和步骤，以横向图方式展示代码如何对应真实业务逻辑。

这让它不仅是代码结构工具，也可以作为产品、业务和技术之间的沟通媒介。

### 7. 知识库图谱

`/understand-knowledge ~/path/to/wiki` 可以分析 Karpathy-pattern LLM Wiki 风格的知识库：

- 解析 `index.md`、wikilinks 和分类；
- 抽取实体、主张和隐式关系；
- 生成带社区聚类的力导向知识图谱；
- 将静态 wiki 转换成可探索的知识网络。

## 工作机制

Understand Anything 采用 Tree-sitter 与 LLM 混合架构：

- Tree-sitter 负责确定性结构解析：语法树、导入导出、函数/类定义、调用点、继承关系等；
- LLM 负责语义理解：自然语言摘要、标签、架构层判断、业务域映射、导览生成、语言概念解释。

这种分工让结构关系具备可复现性，同时保留 LLM 对意图和业务含义的理解能力。

## 多 Agent Pipeline

`/understand` 会编排多个专门 Agent：

| Agent | 职责 |
| --- | --- |
| project-scanner | 发现文件、识别语言和框架 |
| file-analyzer | 抽取函数、类、导入关系，生成图节点和边 |
| architecture-analyzer | 识别架构层 |
| tour-builder | 生成学习导览 |
| graph-reviewer | 校验图谱完整性和引用一致性 |
| domain-analyzer | 提取业务域、流程和步骤 |
| article-analyzer | 分析知识库文章中的实体、主张和隐式关系 |

文件分析支持并行处理，并支持增量更新：默认只重新分析发生变化的文件。

## 安装与使用

Claude Code 原生插件安装：

```bash
/plugin marketplace add Lum1104/Understand-Anything
/plugin install understand-anything
```

通用安装方式（macOS / Linux）：

```bash
curl -fsSL https://raw.githubusercontent.com/Lum1104/Understand-Anything/main/install.sh | bash
```

也可以指定平台：

```bash
curl -fsSL https://raw.githubusercontent.com/Lum1104/Understand-Anything/main/install.sh | bash -s codex
curl -fsSL https://raw.githubusercontent.com/Lum1104/Understand-Anything/main/install.sh | bash -s hermes
```

支持的平台包括：Claude Code、Cursor、VS Code + Copilot、Copilot CLI、Codex、OpenCode、OpenClaw、Antigravity、Gemini CLI、Pi Agent、Vibe CLI、Hermes、Cline、KIMI CLI 等。

常用命令：

```bash
# 分析当前项目
/understand

# 使用中文生成图谱说明和 Dashboard UI
/understand --language zh

# 打开可视化仪表盘
/understand-dashboard

# 询问代码库问题
/understand-chat How does the payment flow work?

# 分析当前改动影响
/understand-diff

# 深入解释某个文件或函数
/understand-explain src/auth/login.ts

# 生成新人 onboarding 指南
/understand-onboard

# 分析业务域
/understand-domain

# 分析知识库
/understand-knowledge ~/path/to/wiki

# 只分析子目录，适合大型 monorepo
/understand src/frontend

# 提交后自动增量更新图谱
/understand --auto-update
```

## 团队共享方式

图谱本质上是 JSON 文件，可以提交到仓库供团队共享。

建议提交：

```text
.understand-anything/knowledge-graph.json
```

建议忽略本地中间文件：

```text
.understand-anything/intermediate/
.understand-anything/diff-overlay.json
```

如果图谱超过 10MB，可以使用 Git LFS 管理。

## 与现有工具的关系

- 与传统静态分析相比：它不仅抽取结构，还用 LLM 生成语义摘要和业务解释。
- 与普通 RAG 相比：它强调图谱结构、依赖关系、导览路径和改动影响，而不是只做向量检索。
- 与 Obsidian / LLM Wiki 相比：它可以把已有知识库转换为交互式图谱，适合做知识网络探索。
- 与 AI 编程 Agent 相比：它是 Agent 的“项目理解层”，可帮助 Claude Code、Codex、Hermes 等工具更快获得上下文。

## 关注点

- 大型项目的初次分析可能需要较长时间和较多模型调用成本。
- LLM 生成的语义摘要需要结合代码事实校验，不能完全当作源码真相。
- 如果要在团队中长期使用，需要建立图谱更新策略，例如提交前手动更新或使用 post-commit hook。
- 对 monorepo 最好先按子目录分区分析，避免一次性图谱过大。

## 后续研究价值

Understand Anything 值得关注的原因在于，它把“代码理解”从聊天式问答推进到“可视化结构 + 语义解释 + 影响分析 + 导览学习”的复合形态。

可进一步观察：

- 它在 Hermes / Codex / Claude Code 多 Agent 开发工作流中的实际效果；
- 图谱是否能成为项目长期知识资产，而不是一次性分析产物；
- 对大型企业级项目、遗留系统和多语言 monorepo 的表现；
- 代码图谱与 Obsidian 知识库、LLM Wiki、团队文档之间的联动方式。

## 链接

- GitHub: https://github.com/Lum1104/Understand-Anything
- Stars: 29.1k
- Forks: 2.4k
- License: MIT
