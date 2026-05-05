---
title: Infisical - 开源密钥与特权访问管理平台
date: 2026-05-05
slug: infisical---开源密钥与特权访问管理平台
tags: [open-source, secret-management, devops, devsecops, infrastructure, pki, best-practices, self-hosted]
categories: [AI]
draft: false
source: https://github.com/Infisical/infisical
author: Infisical
---

## 简介

Infisical 是一个开源的密钥（Secrets）、证书（Certificates）和特权访问管理（PAM）平台。团队可以用它集中管理应用配置和密钥（API Key、数据库凭证），并管理内部 PKI 基础设施。相当于开源版 HashiCorp Vault 的现代替代方案。

## 核心特性

- **密钥管理**：集中管理团队和基础设施的 API Key、数据库凭证等敏感配置，支持版本控制和审计日志
- **证书管理**：内部 PKI 管理，自动化证书签发和轮换
- **KMS 密钥管理**：Infisical Key Management System，统一密钥生命周期管理
- **SSH 访问管理**：Infisical SSH，控制服务器访问权限
- **密钥扫描**：支持 140+ 种密钥类型的扫描，可扫描文件、目录和 Git 仓库历史；支持 pre-commit hook 集成
- **多种部署方式**：Cloud 托管 / 自托管 / 本地 Docker 一行启动
- **客户端工具**：CLI + SDK（Node.js、Python、Go、Ruby、Java、PHP、Rust、Dart 等主流语言）

## 许可证

核心代码 MIT License，企业功能（ee 目录）需 Infisical 商业许可。

## 链接

- 官网：https://infisical.com
- 文档：https://infisical.com/docs/documentation/getting-started/introduction
- 自托管指南：https://infisical.com/docs/self-hosting/overview
- Slack 社区：https://infisical.com/slack
