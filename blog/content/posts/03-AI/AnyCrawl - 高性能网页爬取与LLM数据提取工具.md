---
title: AnyCrawl - 高性能网页爬取与LLM数据提取工具
date: 2026-04-21
slug: anycrawl---高性能网页爬取与llm数据提取工具
tags: [open-source, web-crawler, web-scraping, llm, data-extraction, nodejs, typescript, serp, search-engine]
categories: [AI]
draft: false
source: https://github.com/any4ai/anycrawl
author: any4ai
---

## 简介

AnyCrawl 是一个高性能爬取和抓取工具包，将网站转化为 LLM 可用的数据，并支持从 Google/Bing/百度等搜索引擎提取结构化 SERP 结果。基于 Node.js/TypeScript，支持原生多线程批量处理。

## 核心特性

- **SERP 爬取**：支持 Google、Bing、百度等多搜索引擎，批量友好
- **网页抓取**：单页内容提取，支持 cheerio（最快）、Playwright、Puppeteer 三种引擎
- **全站爬取**：整站遍历与采集，可控制深度和数量
- **LLM 结构化提取**：通过 JSON Schema 定义，LLM 驱动从页面提取结构化数据
- **高性能**：多线程/多进程原生支持
- **Docker 自部署**：支持 Docker Compose 一键部署
- **缓存控制**：支持 S3/本地缓存，可配置过期策略

## 链接

- GitHub：https://github.com/any4ai/anycrawl
- 文档：https://docs.anycrawl.dev
