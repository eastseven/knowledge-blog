---
title: Mole
date: 2026-05-06
slug: mole---mac-深度清理优化工具
tags: [open-source, mac-tool, system-utility, cli, disk-cleaner, system-monitor, developer-tools, homebrew]
categories: [AI]
draft: false
source: https://github.com/tw93/Mole
author: tw93
---

## 简介

Mole 是一个 macOS 系统清理和优化工具，集合了 CleanMyMac + AppCleaner + DaisyDisk + iStat Menus 的功能于一体，通过命令行操作，轻量高效。

## 核心特性

- **深度清理**：清除缓存、日志、浏览器残留、孤立应用数据，回收大量磁盘空间
- **智能卸载**：移除应用及其关联的启动代理、偏好设置、隐藏残留文件
- **磁盘分析**：可视化磁盘使用，查找大文件，支持交互式导航
- **实时监控**：CPU、GPU、内存、磁盘、网络的实时状态面板
- **项目清理**：清理 node_modules、target、.build 等构建产物
- **安全设计**：默认安全优先，路径校验、受保护目录规则、确认机制，支持 `--dry-run` 预览
- **JSON 输出**：analyze 和 status 支持 `--json`，方便脚本集成

## 安装

```bash
brew install mole
```

## 链接

- GitHub: https://github.com/tw93/Mole
