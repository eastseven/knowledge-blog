---
title: Oh My Pi (omp)
date: 2026-08-15
slug: "oh-my-pi---终端ai编码代理(pi增强版,harness优化)---omp"
tags: [ai-agent, coding-assistant, terminal, cli, rust, typescript, mcp, llm, open-source, dev-tools, subagents]
categories: [AI]
draft: false
source: "https://github.com/can1357/oh-my-pi"
author: "can1357"
---

# Oh My Pi (omp)

## 简介

Oh My Pi（命令名 `omp`）是 can1357 基于 Mario Zechner 的 [Pi](https://github.com/badlogic/pi-mono) 深度改造的终端 AI 编码代理，口号是 "A coding agent with the IDE wired in"。核心理念：不换模型，只靠优化工具管线（harness）榨出模型的全部能力——官方基准显示 Grok Code Fast 1 编辑成功率从 6.7% 提升到 68.3%，Grok 4 Fast 输出 token 减少 61%，MiniMax 通过率翻倍（同一权重同一提示词）。技术栈为 TypeScript + 约 8 万行 Rust 原生核心，MIT 协议，支持 macOS / Linux / Windows 原生运行（无需 WSL）。

基本盘：60+ 模型 Provider、31 个内置工具、14 种 LSP 操作、28 种 DAP 调试操作、18,104 次提交，24.7k stars。

## 核心特性

### 编辑格式：Hashline 内容哈希锚点

模型不重写整行而是指向锚点（anchor），空白冲突和"字符串找不到"死循环消失；编辑过期文件时锚点发散，补丁在污染文件前被拒绝。配套 ast_edit 结构化重写：先返回 (proposed) 预览卡片，代理写入一行理由到 `xd://resolve` 后原子落盘。这是整个项目性能提升的最大来源（详见作者博文 The Harness Problem）。

### 工具链全部进程内原生化

其他 agent 每次调用都要 fork-exec rg/grep/find/bash；omp 把真实实现直接链入进程——ripgrep、glob、find 进程内执行；brush（bash 的 Rust 实现）作为嵌入式 shell，会话跨调用存活；58+ 个命令行工具（ls、sed、sort、xargs、jq 等）移植进 builtins crate，零 fork/exec。热路径上没有进程创建开销，这也是 Windows 能原生跑的原因。

Rust 核心分六个 crate：

| Crate | 职责 | 约代码行 |
| --- | --- | --- |
| pi-shell | 嵌入式 bash 引擎、持久会话、内置命令分发 | 38,000 |
| pi-natives | N-API 绑定层（desktop/grep/diff/pty/clipboard 等全部模块） | 25,000 |
| pi-walker | 并行忽略感知文件遍历 + 扫描缓存（grep/glob/workspace 共享） | 5,200 |
| pi-iso | 任务隔离后端：APFS 克隆、btrfs/zfs reflink、overlayfs、projfs、rcopy | 3,300 |
| pi-ast | tree-sitter 代码摘要与 AST 工具（50+ 语言语法） | 2,900 |
| pi-voice | 音频采集播放、Opus 编解码、WebRTC 流 | 1,000 |

### 21 个差异化能力（挑重点）

- 双内核代码执行：持久 Python 和 Bun worker，且两个内核都能通过环回桥回调 agent 自己的工具（read/search/task）——在 Python 单元格里用 tool.read 加载 CSV，再从 JavaScript 画图，不离开 cell。
- LSP 接入每次写入：rename 走 workspace/willRenameFiles，再导出、barrel 文件、别名 import 在文件移动前同步更新。
- 真实调试器驱动：C 程序段错误挂 lldb 单步到坏指针、Go 服务卡死挂 dlv 遍历 goroutine、Python 楔死用 debugpy 暂停检查——28 种 DAP 操作。
- Time-traveling stream rules：规则平时休眠，模型跑偏时正则命中即中断流式输出（mid-token）、注入系统提醒、从断点重试；注入内容能在上下文压缩后存活。
- 一等公民 subagents：task 扇出到隔离 worktree，各自独立工具面，结果为 schema 验证的结构化对象（无需解析散文）；Alt+A 打开 Agent Hub 实时查看每个子代理的活动和用量、发转向消息、复活或击杀。
- advisor 审查模型：第二个模型以 advisor 角色逐轮阅读主代理输出，独立上下文独立模型，内联注入提示/担忧/硬阻断。
- /collab 协作：会话上 relay 得到链接+二维码，队友 omp join 或浏览器直接加入，支持读写配对和只读观摩；帧客户端加密，relay 看不到密钥。
- GitHub 即文件系统：不搞 gh_issue_view 这类专用工具，PR 就是路径，read/grep 统一处理。16 种内部 scheme：`pr://`、`issue://`、`agent://`、`skill://`、`ssh://`、`conflict://` 等，`read pr://1428` 与 `read src/foo.ts` 同构，`agent:///findings.0.path` 按路径取子代理输出字段。
- 合并冲突解决：每个冲突一个 URL，写 `@theirs`/`@ours`/`@base` 到 `conflict://N` 即净解，批量 `conflict://*`。
- web_search 23 个后端链（perplexity/gemini/xai/exa/tavily/kagi/brave/searxng/duckduckgo 等），site-aware 抽取把 GitHub、npm/PyPI/crates.io、arXiv、Stack Overflow、MDN 转成锚点完整的结构化 markdown；另内置 NVD/OSV/CISA KEV 漏洞库查询。
- 真浏览器 + 桌面控制：browser 工具默认 stealth、可驱动任意 Electron 应用（如读 Slack DM），browser-relay 扩展能直接接管你已打开的 Chrome 标签页；computer 工具跑持久 JS 操作真实桌面——枚举窗口、截图、原生输入、走 OS 辅助功能树、读写剪贴板。
- /review 代码审查：专用审查子代理并行扫分支/单提交/未提交改动，输出 P0-P3 优先级排序 + 置信度评分 + 明确的"能不能发布"结论。
- omp commit：通过 git_overview/git_file_diff/git_hunk 读工作区，把无关改动按依赖顺序拆成原子提交，循环依赖写入前拒绝，源码文件排序高于测试/文档/配置。
- 记忆系统：retain 写事实、learn 收集可复用教训（可提升为托管 skill）、recall 取回、reflect 综合，会话结束时压缩成心智模型供下次首轮加载；backend 可选 local / Hindsight / Mnemopi，默认项目作用域。
- ACP 协议：在 Zed 里跑的就是终端里同一个 agent，读你正在看的 buffer、走编辑器保存路径写文件、在编辑器终端里开 shell。
- 配置继承：首启直接读磁盘上已有的 8 种格式——Cursor MDC、Cline .clinerules、Codex AGENTS.md、Copilot applyTo、.claude、.windsurf、.gemini 等，零迁移脚本。
- Magic keywords：正文里写 ultrathink（最高思考力度）、orchestrate（并行子代理分阶段验证）、workflowz（确定性多子代理工作流）即触发专用行为，代码块和标识符里不误触。

### 31 个内置工具一览

read / write / edit / ast_edit / ast_grep / grep / glob / bash / eval / lsp / debug / security_scan / task / hub / todo / ask / browser / computer / web_search / github / generate_image / inspect_image / tts / checkpoint / rewind / retain / recall / reflect / memory_edit / learn / manage_skill。常用集用 `--tools read,edit,bash,…` 固定；冷门工具藏在 `xd://` 设备后面，`read xd://` 列出、`write xd://` 运行。read 单一工具通吃文件、目录、压缩包、SQLite、PDF、notebook、URL、ssh:// 远程路径和全部内部 scheme。

### 模型路由：60+ Provider、10 种角色

- 前沿 API：Anthropic（OAuth）、OpenAI、OpenAI Codex、Gemini / Vertex、xAI / SuperGrok、DeepSeek、Mistral、Groq、Cerebras、Bedrock、Azure、OpenRouter、SiliconFlow 等。
- 编码订阅计划（`/login` 附着）：Cursor、GitHub Copilot、GitLab Duo、Devin、Kimi Code、MiniMax Coding Plan（含 CN）、Alibaba Coding Plan、Qwen Portal、Z.AI / GLM Coding Plan、Xiaomi MiMo 等。
- 本地自跑：Ollama、LM Studio、llama.cpp、vLLM、LiteLLM（OpenAI 兼容 `/v1/models`，本地免 key）。
- 自定义 OpenAI 兼容 provider 写 `~/.omp/agent/models.yml`，`omp models <name>` 验证发现。

十种角色按意图路由：default（常规轮）/ smol（便宜子代理扇出）/ slow（深度推理）/ plan（计划模式）/ commit（变更日志）/ vision / designer / task / advisor / tiny。`--smol`、`--slow`、`--plan` 启动时覆盖，Ctrl+P 循环切换，/model 会话中换。四个进阶旋钮：per-role fallback chains（429/配额墙自动切下一个）、path-scoped models（按路径前缀锁定某仓库的模型集）、round-robin 多 key 轮换（带会话亲和和单 key 退避）。

### 四种入口

| 入口 | 命令 | 场景 |
| --- | --- | --- |
| 交互 TUI | `omp` | 默认，工具调用渲染为卡片、编辑先预览、歧义走 ask 选择器 |
| 一次性 | `omp -p "提示词"` | 单发即退出 |
| Node SDK | `@oh-my-pi/pi-coding-agent` | 嵌入自有进程，暴露 ModelRegistry / SessionManager / createAgentSession |
| RPC / ACP | `omp --mode rpc`、`omp acp` | NDJSON over stdio 驱动；ACP 供 Zed 等编辑器，写操作走权限确认 |

## 安装

- Homebrew：`brew install can1357/tap/omp`
- Bun（官方推荐）：`bun install -g @oh-my-pi/pi-coding-agent`（需 bun ≥ 1.3.14）
- Nix：flake 提供 packages/overlays/nixosModules/homeManagerModules，Home Manager 可声明式接管配置
- mise 固定版本：`mise use -g github:can1357/oh-my-pi`
- 官网一键脚本见 [omp.sh](https://omp.sh)；Alpine/musl 需先 `apk add libstdc++ libgcc`
- 自带 bash/zsh/fish 补全：`eval "$(omp completions zsh)"`，模型名和会话恢复都能补全

## 链接

- 仓库：https://github.com/can1357/oh-my-pi
- 官网/文档：https://omp.sh
- Harness Problem 博文（性能数据来源）：https://blog.can.ac/2026/02/12/the-harness-problem/
- 工具参考：https://omp.sh/docs/tools
- Provider 参考：https://omp.sh/docs/providers
- 上游 Pi：https://github.com/badlogic/pi-mono
- npm：https://www.npmjs.com/package/@oh-my-pi/pi-coding-agent
- Discord：https://discord.gg/4NMW9cdXZa
