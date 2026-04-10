---
title: "Andrej Karpathy Skills"
date: 2026-04-10
slug: andrej-karpathy-skills---llm编码准则
tags: [open-source, llm-coding, claude-code, best-practices, karpathy, prompt-engineering, coding-guidelines]
categories: [AI]
draft: false
source: https://github.com/forrestchang/andrej-karpathy-skills
author: forrestchang
---

# Andrej Karpathy Skills - LLM 编码准则

## 简介

一个 CLAUDE.md 文件，源自 Andrej Karpathy 对 LLM 编码常见问题的观察总结，用于改善 Claude Code 的行为。

## Karpathy 指出的 LLM 编码问题

- 模型会默默做出错误假设，不检查就一路走下去
- 不管理困惑、不寻求澄清、不暴露矛盾、不展示权衡
- 喜欢过度复杂化代码和 API，臃肿的抽象，不清理死代码
- 100 行能搞定的事写成 1000 行
- 有时会误删/修改它们不完全理解的注释和代码

## 四大原则

### 1. Think Before Coding（先思考再编码）
- 不假设、不隐藏困惑、展示权衡
- 明确陈述假设 — 不确定就问，不要猜
- 展示多种理解 — 有歧义时不要静默选择
- 该反驳就反驳 — 如果有更简单的方案，直说
- 困惑时停下来 — 说出不清楚的地方，请求澄清

### 2. Simplicity First（简洁优先）
- 用最少的代码解决问题，不写投机性代码
- 不添加没要求的功能、不为单次使用建抽象
- 不搞没请求的"灵活性"和"可配置性"
- 如果 200 行可以写成 50 行，就重写
- 检验标准：高级工程师会认为这过于复杂吗？

### 3. Surgical Changes（精准修改）
- 只触碰必要的代码，只清理自己制造的混乱
- 不"改善"相邻代码、注释或格式
- 不重构没坏的东西，匹配已有风格
- 你的改动产生的废弃代码要删掉，但预存的死代码只提不删
- 检验标准：每一行改动都能追溯到用户的请求

### 4. Goal-Driven Execution（目标驱动执行）
- 定义成功标准，循环直到验证通过
- 把命令式任务转化为可验证的目标：
  - "添加验证" → "为无效输入写测试，然后让它们通过"
  - "修复 bug" → "写一个复现它的测试，然后让测试通过"
  - "重构 X" → "确保重构前后测试都通过"
- 多步任务先列计划，每步附验证检查点

## 安装方式

**Claude Code 插件（推荐）：**
```
/plugin marketplace add forrestchang/andrej-karpathy-skills
/plugin install andrej-karpathy-skills@karpathy-skills
```

**CLAUDE.md（按项目）：**
```
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
```

## 核心洞见

> "LLMs are exceptionally good at looping until they meet specific goals... Don't tell it what to do, give it success criteria and let it loop."

## 链接

- GitHub: https://github.com/forrestchang/andrej-karpathy-skills
