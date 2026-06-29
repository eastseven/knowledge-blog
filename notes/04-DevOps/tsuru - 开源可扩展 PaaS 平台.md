---
title: tsuru
date: 2026-06-29
slug: "tsuru---开源可扩展-paas-平台"
tags: [open-source, paas, devops, kubernetes, docker, containers, platform-engineering, application-deployment, go, cloud-native, infrastructure, self-hosted, github-repo]
categories: [DevOps]
draft: false
source: "https://github.com/tsuru/tsuru"
author: "tsuru"
---

## 简介

tsuru 是一个开源、可扩展的 Platform as a Service（PaaS）平台，目标是让应用部署更快、更简单。它隐藏底层服务器和基础设施细节，让开发者可以专注于应用本身，并通过命令行工具完成应用管理与部署。

项目主要使用 Go 编写，围绕容器、Kubernetes、Docker 和 DevOps 场景构建，适合关注平台工程、内部开发者平台、私有 PaaS 或云原生应用交付的团队参考。

## 核心特性

- 支持多语言应用部署，包括 Python、Node.js、Go、Ruby、PHP、Perl、Lua、Java 等。
- 支持通过 add-on 资源为应用挂载 SQL、NoSQL、memcached、Redis 等服务。
- 提供 tsuru CLI，用于应用创建、部署、管理和目标环境切换。
- 面向 Kubernetes 集群运行，可用于构建自托管 PaaS / 内部开发者平台。
- 提供本地开发环境，依赖 docker/podman、minikube、go、yq 等工具。
- 支持团队、pool、cluster 等平台级资源管理，便于多团队应用交付。

## 适合关注

- 内部开发者平台（Internal Developer Platform, IDP）
- 自托管 PaaS 与 Heroku-like 平台
- Kubernetes 上的应用交付抽象
- DevOps / 平台工程工具链
- 多语言应用统一部署入口

## 链接

- GitHub: https://github.com/tsuru/tsuru
- 官网: https://tsuru.io
- 文档: https://docs.tsuru.io/
- tsuru-client Releases: https://github.com/tsuru/tsuru-client/releases/
- 贡献指南: https://docs.tsuru.io/contributing/docker-compose/
