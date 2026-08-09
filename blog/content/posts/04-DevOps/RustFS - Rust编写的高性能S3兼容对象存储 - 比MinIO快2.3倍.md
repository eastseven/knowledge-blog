---
title: RustFS — Rust 编写的高性能 S3 兼容对象存储
date: 2026-08-09
slug: "rustfs---rust编写的高性能s3兼容对象存储---比minio快2.3倍"
tags: [对象存储, S3, Rust, 分布式存储, 高性能, 开源, 数据湖, AI存储, MinIO替代, Apache-2.0, cloud-native, bitrot, self-hosted]
categories: [DevOps]
draft: false
source: "https://github.com/rustfs/rustfs"
author: "rustfs"
---

# RustFS — Rust 编写的高性能 S3 兼容对象存储

## 一句话简介

RustFS 是用 Rust 编写的高性能分布式对象存储系统，完整兼容 S3 API，定位为 MinIO 的替代方案。4KB 小对象场景下速度比 MinIO 快 2.3 倍。

## 核心特点

- 高性能：Rust 构建，最大化速度与资源效率，4KB 载荷下比 MinIO 快 2.3 倍
- 分布式架构：可扩展、容错，适合大规模部署
- S3 兼容：广泛兼容 S3 API，可与 MinIO / Ceph 等 S3 兼容平台迁移和共存
- OpenStack Swift API：原生支持 Swift 协议 + Keystone 认证
- 数据湖优化：针对高吞吐大数据和 AI 工作负载优化
- 许可证优势：Apache 2.0（商业友好），避开 AGPL 的"毒丸"限制
- 无遥测：符合 GDPR（欧盟/英国）、CCPA（美国）、APPI（日本）数据合规要求

## 与 MinIO 的关键差异

| 维度 | RustFS | MinIO / 其他 |
| --- | --- | --- |
| 语言 | Rust（内存安全，无 GC 停顿） | Go（可能有 GC 停顿/内存泄漏） |
| 许可证 | Apache 2.0（商业友好） | AGPL v3（限制性强，有许可证陷阱风险） |
| 数据主权 | 无遥测，全合规 | 可能有数据遥测风险 |
| 控制台 | 功能全面的管理界面 | 基础/有限 |
| 边缘支持 | 轻量，适合边缘网关 | 过重，不适合边缘 |

## 功能状态

| 功能 | 状态 |
| --- | --- |
| S3 核心功能 / 上传下载 | ✅ 可用 |
| 版本控制 | ✅ 可用 |
| 日志 / 事件通知 | ✅ 可用 |
| K8s Helm Charts | ✅ 可用 |
| Keystone 认证 | ✅ 可用 |
| Bitrot 保护 | ✅ 可用 |
| 单节点模式 | ✅ 可用 |
| Bucket 复制 | ✅ 可用 |
| 多租户 | ✅ 可用 |
| Swift API | ✅ 可用 |
| 生命周期管理 | 🚧 测试中 |
| 分布式模式 | 🚧 测试中 |
| RustFS KMS | 🚧 测试中 |
| Swift 元数据操作 | 🚧 部分支持 |

## 快速部署

Docker 单节点：
```bash
mkdir -p data logs
chown -R 10001:10001 data logs

# 最新版
docker run -d --name rustfs \
  -p 9000:9000 -p 9001:9001 \
  -v $(pwd)/data:/data \
  -v $(pwd)/logs:/logs \
  rustfs/rustfs:latest

# 控制台: http://localhost:9001
# 默认账号: rustfsadmin / rustfsadmin
```

Docker Compose（含 Grafana/Prometheus/Jaeger 可观测性栈）：
```bash
docker compose -f docker-compose-simple.yml up -d
```

其他部署方式：源码构建（多架构 docker-buildx.sh）、Helm Chart（K8s）、Nix Flake、X-CMD。

## 技术栈

- 语言：Rust
- 架构：crates/ 工作空间（多 crate 模块化）
- 容器：非 root 用户运行（UID/GID 10001:10001）
- 可观测：Grafana + Prometheus + Jaeger 集成
- 安全：TLS 支持、OIDC 认证（含 Microsoft Entra ID roles_claim 映射）、Webhook 事件通知（含出站连接白名单策略）

## 仓库信息

- Stars：30.7k | Forks：1.4k | Commits：5260+
- 5260+ commits，活跃开发中
- 入选 ROSS Index（Q4 2025 最快增长开源创业项目）
- 文档：https://docs.rustfs.com
- 社区：Discord / GitHub Discussions
