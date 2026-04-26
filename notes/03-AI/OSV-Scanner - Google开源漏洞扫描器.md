---
title: OSV-Scanner
date: 2026-04-27
slug: osv-scanner---google开源漏洞扫描器
tags: [open-source, security, vulnerability-scanner, devops, dependency-management, supply-chain-security, go, best-practices]
categories: [AI]
draft: false
source: https://github.com/google/osv-scanner
author: google
---

## 简介

OSV-Scanner 是 Google 开源的漏洞扫描工具，基于 Go 编写，使用 [OSV.dev](https://osv.dev) 数据库扫描项目依赖中的已知安全漏洞。提供 OSV 数据库的官方前端接口和 OSV-Scalibr 的 CLI 接口。

## 核心特性

- **多语言支持**: C/C++, Dart, Elixir, Go, Java, JavaScript, PHP, Python, R, Ruby, Rust
- **多包管理器**: npm, pip, yarn, maven, go modules, cargo, gem, composer, nuget 等
- **操作系统包扫描**: 检测 Linux 系统上的 OS 包漏洞
- **容器镜像扫描**: 层级感知的容器漏洞扫描，支持 Alpine/Debian/Ubuntu 基础镜像
- **许可证扫描**: 基于 deps.dev 数据检查依赖许可证合规性
- **离线扫描**: 支持下载本地数据库后离线运行
- **引导修复(Guided Remediation)**: 根据依赖深度、严重程度、修复策略等建议升级方案（实验性）
- **Call Analysis**: 分析是否实际调用了有漏洞的函数，减少误报
- ** Vendored C/C++ 检测**: 扫描内嵌的 C/C++ 代码

## 链接

- GitHub: https://github.com/google/osv-scanner
- OSV 数据库: https://osv.dev
- 文档: https://google.github.io/osv-scanner/
