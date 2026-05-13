---
title: Homepage
date: 2026-05-13
slug: homepage---可高度定制的自托管应用仪表盘
tags: [open-source, self-hosted, dashboard, homepage, startpage, docker, docker-compose, yaml, service-discovery, widgets, homelab, devops, nextjs, application-dashboard, reverse-proxy, security, i18n, productivity]
categories: [DevOps]
draft: false
source: https://github.com/gethomepage/homepage
author: gethomepage
---

# Homepage

## 简介

Homepage 是一个现代化、自托管、可高度定制的主页 / 起始页 / 应用仪表盘项目。它适合 homelab、NAS、自托管服务入口、团队内部工具导航等场景，可以通过 YAML 配置或 Docker Label 自动发现服务，并集成大量第三方服务 API 与信息组件。

项目定位：一个快速、安全、支持 Docker 集成和服务 API 集成的应用仪表盘。

## 核心特性

- **静态生成与高性能**：站点在构建时静态生成，加载速度快。
- **安全代理 API 请求**：后端服务 API 请求通过 Homepage 代理，避免直接暴露 API Key。
- **Docker 集成**：支持读取容器状态、统计信息，也可以通过 Docker labels 自动发现服务。
- **服务集成丰富**：支持超过 100 个服务集成，覆盖常见自托管应用与 *arr 生态，例如 Radarr、Sonarr、Lidarr、Bazarr、Plex、Jellyfin、Emby、Transmission、qBittorrent、Deluge 等。
- **信息组件**：支持天气、时间、日期、搜索、系统状态、Glances 等信息展示。
- **书签与链接管理**：可以把常用服务、网页链接集中到一个统一入口。
- **高度定制**：支持主题、自定义 CSS / JS、布局、格式化、本地化等配置。
- **多架构镜像**：支持 AMD64 和 ARM64。
- **多语言支持**：支持 40+ 语言。

## 典型使用场景

- 自托管服务统一入口。
- Homelab / NAS 首页。
- Docker Compose 服务看板。
- 家庭服务器或内网服务导航。
- 聚合服务状态、系统信息、天气和常用链接。
- 为反向代理后面的多个服务提供统一起始页。

## Docker Compose 示例

```yaml
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    environment:
      HOMEPAGE_ALLOWED_HOSTS: gethomepage.dev # 按实际域名或域名:端口配置
      PUID: 1000
      PGID: 1000
    ports:
      - 3000:3000
    volumes:
      - /path/to/config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro # 可选，用于 Docker 集成
    restart: unless-stopped
```

## docker run 示例

```bash
docker run --name homepage \
  -e HOMEPAGE_ALLOWED_HOSTS=gethomepage.dev \
  -e PUID=1000 \
  -e PGID=1000 \
  -p 3000:3000 \
  -v /path/to/config:/app/config \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --restart unless-stopped \
  ghcr.io/gethomepage/homepage:latest
```

## 从源码运行

```bash
git clone https://github.com/gethomepage/homepage.git
cd homepage
pnpm install
pnpm build
pnpm start
```

开发模式：

```bash
pnpm install
pnpm dev
```

打开：`http://localhost:3000`

## 配置方式

Homepage 主要通过配置文件管理：

- YAML 配置文件
- Docker labels 自动发现服务
- 自定义主题、布局、CSS、JS
- 服务 widgets 与信息 providers

官方文档提供了完整配置说明，实际使用前建议优先阅读文档。

## 安全注意事项

Homepage 本身不计划内置认证层。如果将 Homepage 暴露到不可信网络，必须放在反向代理或 VPN 后面，并由外部组件负责：

- 身份认证
- TLS
- Host Header 校验
- 访问控制

内置 host check 只能作为基础防护，不能替代正式的安全边界。

## 技术信息

- 类型：自托管应用仪表盘 / startpage / homepage
- 技术栈：Next.js、Docker、YAML 配置
- 镜像：`ghcr.io/gethomepage/homepage:latest`
- 默认端口：`3000`
- GitHub Stars：约 30k
- GitHub Forks：约 1.9k

## 链接

- GitHub：https://github.com/gethomepage/homepage
- 官方文档：https://gethomepage.dev/
- Docker 镜像：`ghcr.io/gethomepage/homepage:latest`
