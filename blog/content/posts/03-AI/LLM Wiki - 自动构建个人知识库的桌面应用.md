---
title: LLM Wiki
date: 2026-05-20
slug: "llm-wiki---自动构建个人知识库的桌面应用"
tags: [open-source, github, ai-agent, llm, knowledge-base, personal-knowledge-management, llm-wiki, obsidian, desktop-app, tauri, rag-alternative, knowledge-graph, vector-search, semantic-search, deep-research, chrome-extension, local-first, typescript]
categories: [AI]
draft: false
source: "https://github.com/nashsu/llm_wiki"
author: "nashsu"
---

# LLM Wiki

## 简介

LLM Wiki 是一个跨平台桌面应用，用来把个人文档自动整理成结构化、可互链、可持续维护的知识库。它不是每次提问时临时检索并重新生成答案的传统 RAG 方式，而是让 LLM 在导入资料时增量地阅读、分析、生成并维护 wiki 页面，让知识“编译一次、持续更新”。

项目实现了 Andrej Karpathy 提出的 LLM Wiki 模式，并把原本偏方法论的设计扩展为完整桌面产品：支持文件导入、知识树、聊天、预览、搜索、图谱、Lint、人工审阅、Deep Research、设置等界面。

- GitHub: https://github.com/nashsu/llm_wiki
- 作者: nashsu
- 主要语言: TypeScript
- Stars: 8388
- Forks: 1029

## 核心理念

LLM Wiki 的基本思路是：

1. Raw Sources：原始资料不可变保存。
2. Wiki：由 LLM 生成并维护的结构化知识页面。
3. Schema：约束 wiki 的规则、结构和配置。

它保留了 Karpathy LLM Wiki 模式中的关键元素：

- `index.md` 作为内容目录和 LLM 导航入口。
- `log.md` 记录可解析的操作日志。
- `[[wikilink]]` 作为知识页面之间的交叉引用。
- 每个 wiki 页面使用 YAML frontmatter。
- 兼容 Obsidian，wiki 目录可以作为 Obsidian vault 使用。
- 人类负责策展和判断，LLM 负责维护和生成。

## 主要特性

### 1. 两阶段 Chain-of-Thought 导入

项目把资料导入拆成两个 LLM 调用阶段：

1. 分析阶段：LLM 读取来源文档，提取实体、概念、论点、与现有知识的连接、冲突和结构建议。
2. 生成阶段：LLM 根据分析结果生成或更新 wiki 页面、索引、日志、概览和人工审阅项。

这样可以提升生成质量，也更容易保留来源可追溯性。

### 2. 增量缓存与持久化导入队列

- 使用 SHA256 哈希判断源文件是否变化，未变化的文件自动跳过。
- 导入队列持久化到磁盘，应用重启后仍可恢复。
- 支持失败任务重试、取消、进度展示。
- 文件夹导入会保留目录结构，并把路径上下文传给 LLM 辅助分类。
- `raw/sources/` 中外部新增、修改或删除的文件可被自动监听并同步处理。

### 3. 多模态图片导入

支持从 PDF 中提取嵌入图片，用视觉模型生成事实性 caption，并在图片感知搜索结果中展示，支持预览和跳转来源。

### 4. 知识图谱与相关性模型

项目不仅使用 wikilink，还构建了知识图谱和相关性模型。相关性由四类信号组合：

- 直接链接：页面之间存在 `[[wikilink]]`。
- 来源重叠：多个页面来自相同原始资料。
- Adamic-Adar：根据共同邻居评估潜在关联。
- 类型亲和：相同页面类型之间加权。

图谱可视化基于 sigma.js、graphology 和 ForceAtlas2，支持节点按类型或社区着色、悬停高亮邻居、缩放、边权显示等。

### 5. Louvain 社区发现

通过 Louvain 算法自动发现知识集群，并提供：

- 自动聚类。
- 页面类型 / 社区视图切换。
- 社区凝聚度评分。
- 低凝聚度社区提示。
- 社区图例和成员统计。

### 6. Graph Insights

系统会从图谱结构中发现值得关注的洞察：

- 跨社区、跨类型或外围节点与枢纽节点之间的意外连接。
- 孤立页面、稀疏社区、桥接节点等知识缺口。
- 对知识缺口可以一键触发 Deep Research。

### 7. 查询检索流水线

查询过程分为多个阶段：

1. 关键词 / 分词搜索：支持英文停用词处理和中文 CJK bigram。
2. 可选向量语义搜索：通过 LanceDB 存储 embedding，支持任意 OpenAI-compatible embeddings endpoint。
3. 图谱扩展：从初始搜索结果出发，通过相关性模型扩展 2-hop 相关页面。
4. 上下文预算控制：按照 wiki 页面、聊天历史、索引、系统提示分配 token 预算。
5. 上下文组装：引用页面编号，要求 LLM 在回答中按编号引用来源。

向量搜索默认关闭，可在设置中开启。README 中给出的 benchmark 显示，开启向量搜索后整体召回从 58.2% 提升到 71.4%。

### 8. 多会话聊天与引用持久化

- 支持多个独立聊天会话。
- 每个会话持久化到 `.llm-wiki/chats/{id}.json`。
- 可配置上下文历史深度。
- 回答中的引用页面会持久保存，重启后仍可查看。
- 支持重新生成最后一次回答。

### 9. Deep Research

支持通过 Tavily、SerpApi 或 SearXNG 进行多查询网页搜索，把搜索结果自动导入 wiki。研究主题可由知识图谱中的 gaps / bridge nodes 触发，也可由用户编辑确认。

### 10. Chrome Web Clipper 与本地 API

- Chrome Web Clipper：一键保存网页并自动导入知识库。
- 本地 HTTP API：运行在 `127.0.0.1:19828`，token 保护，支持 hybrid search、文件读取、图遍历、source rescan 等。
- AI Agent Skill：提供可安装到 Claude Code / Codex 的 agent skill，让外部 coding agent 能调用本地知识库能力。

## 技术栈与形态

从仓库结构和 README 看，项目是桌面应用形态，主要技术包括：

- TypeScript
- Tauri
- React / 前端桌面 UI
- sigma.js / graphology / ForceAtlas2 知识图谱
- LanceDB 向量检索
- OpenAI-compatible LLM / embeddings endpoint
- 可选 Tavily、SerpApi、SearXNG 搜索集成
- Chrome extension / Web Clipper

## 与传统 RAG 的区别

传统 RAG 更像“查询时临时检索并生成答案”；LLM Wiki 更像“持续维护的知识编译系统”。

它的价值在于：

- 导入时就把知识整理成稳定页面。
- 查询时读取已有 wiki 页面，而不是每次从原始资料重新推导。
- 通过 wikilink、frontmatter、index、log、purpose、schema 保持知识结构。
- 人类可以在 Obsidian 中继续编辑和策展。
- 图谱和社区发现可以帮助发现知识之间的隐性联系。

## 适合关注的研究点

这个项目值得重点观察：

1. Karpathy LLM Wiki 模式从“提示词/方法论”到桌面产品的具体落地方式。
2. LLM 维护长期知识库时，如何处理来源追踪、增量更新、审阅和冲突。
3. 知识图谱与向量检索如何互补。
4. 与 Obsidian 兼容的本地优先知识库是否适合个人长期记忆。
5. 本地 HTTP API 和 Agent Skill 能否成为个人知识库与 AI Agent 的桥梁。
6. Deep Research 结果自动入库后，如何避免知识污染和噪声累积。
7. 与 Hermes / MemTensor / TencentDB Agent Memory 等长期记忆方案的区别：LLM Wiki 偏“文档知识库与显式页面维护”，MemTensor 偏“agent memory infrastructure”，TencentDB Agent Memory 偏“分层长期记忆”。

## 可能的使用场景

- 个人论文、网页、文档、笔记的自动化知识整理。
- Obsidian 用户希望用 LLM 自动维护 vault。
- 研究主题长期跟踪，例如 AI agent、LLM memory、产品设计、技术路线调研。
- 给 coding agent 提供本地知识库上下文。
- 用图谱发现资料之间的意外联系和知识缺口。

## 注意事项

- 项目较新，仓库创建于 2026-04，迭代很快，需要关注稳定性和数据迁移风险。
- 自动生成知识页容易出现幻觉或过度整理，人工审阅机制很关键。
- Deep Research 自动入库可能带来噪声，需要设计可靠的策展流程。
- 如果作为长期个人知识库，应重点验证数据目录、备份、导出、Obsidian 兼容性和锁定风险。

## 链接

- GitHub: https://github.com/nashsu/llm_wiki
- 原始方法论来源: Andrej Karpathy 的 LLM Wiki pattern
