  

[VibeCoding工程化](https://claude.ai/project/019d244f-738e-7100-81ca-c9fae521566a)/

Vibe Coding概念解析

Shared by D7

This is a copy of a chat between Claude and D7. Content may include unverified or unsafe content that do not represent the views of Anthropic. Shared snapshot may contain attachments and data not displayed here.

Vibe Coding是什么

3月24日

## Vibe Coding 是什么？

**Vibe Coding**（氛围编程）是一种新兴的 AI 辅助编程方式，由 OpenAI 联合创始人 Andrej Karpathy 于 2025 年初提出并推广。

### 核心理念

与传统编程不同，Vibe Coding 的核心是：

> **不写代码，只描述意图** —— 你告诉 AI 你想要什么，AI 来写代码，你来"感受"（vibe）结果是否符合预期。

开发者不需要深入理解每一行代码，而是通过自然语言与 AI 反复对话，迭代出最终产品。

### 典型工作流程

1. 用自然语言描述你想构建的东西
2. AI（如 Claude、Cursor、GitHub Copilot 等）生成代码
3. 运行代码，看效果
4. 如果不对，继续用自然语言告诉 AI 哪里需要改
5. 重复，直到满意

### 常用工具

- **Cursor** —— AI 优先的代码编辑器
- **Claude / ChatGPT** —— 直接对话生成代码
- **Claude Code** —— 命令行 AI 编程助手
- **v0 by Vercel** —— 专注前端的 AI 生成工具
- **Bolt / Lovable** —— 全栈应用快速生成

### 优点

- 极低的上手门槛，非程序员也能"编程"
- 快速原型开发，想法到产品的速度大大加快
- 让开发者聚焦在产品逻辑而非语法细节

### 局限性

- 生成的代码质量参差不齐，难以维护
- 遇到复杂 bug 时排查困难
- 对系统架构和安全性的把控较弱
- 过度依赖 AI 可能导致开发者自身能力退化

---

简单来说，Vibe Coding 就是 **"用说话来编程"**，把 AI 当成一个全能程序员，自己做产品经理和测试员。它降低了编程门槛，但也带来了代码质量和可维护性的挑战。

VibeCoding如何工程化

3月24日

Vibe Coding 工程化的核心问题是：**如何在保留 AI 速度优势的同时，引入足够的工程约束来保证质量、可维护性和可扩展性。** 以下是系统化的框架：

---

## 一、工程化的核心矛盾

Vibe Coding 的天然优势是速度和灵活，工程化引入的是约束和规范。两者本质上存在张力 —— 工程化的目标不是消除这种张力，而是找到合适的平衡点。

---

## 二、各层的工程实践

### 1. 产品层 — 定义"做什么"

AI 生成的代码质量上限取决于需求的清晰度。工程化的关键是**用结构化文档替代模糊意图**：

- **PRD 模板化**：每个功能写清楚 "用户故事 + 验收标准 + 边界条件"，直接喂给 AI
- **功能拆分到原子级**：每次 Vibe Coding 只做一个明确的小任务（500行以内），避免一次性生成大量不可控代码
- **明确输入输出**：在 Prompt 里描述函数签名、数据结构、API 契约

### 2. 上下文层 — 定义"怎么做"

这是工程化最关键的一层。核心工具是 **`CLAUDE.md`（或 `AGENTS.md`）** —— 一个放在项目根目录的"说明书"，告诉 AI 关于这个项目的一切：

markdown

````markdown
# 项目约定

## 技术栈
- 前端：Next.js 15 + TypeScript + Tailwind
- 后端：FastAPI + PostgreSQL
- 测试：Vitest + Playwright

## 代码规范
- 所有组件必须有 TypeScript 类型
- 禁止使用 any
- 数据库操作必须使用 Repository 模式

## 禁止事项
- 不要修改 /core 目录下的文件
- 不要引入新的依赖，除非先列出原因
```

这个文件会在每次 AI 会话开始时被载入，相当于给 AI 设置了"工程约束"。

### 3. 生成层 — 结构化 Prompt 工程

不是随手一写，而是**建立可复用的 Prompt 模板**：

- **角色 + 任务 + 约束 + 格式**四段式结构
- 先让 AI 输出计划，确认后再生成代码（"think step by step before coding"）
- 使用 `--dangerously-allow-all` 模式（Claude Code）配合 Git 钩子，让 AI 有执行权但有回滚保障
- **任务分解**：复杂功能拆成 `设计 → 数据层 → 业务层 → UI层 → 测试` 五步，每步独立完成

### 4. 验证层 — 自动化兜底

AI 写的代码不能靠人肉 Review，必须有**自动化护网**：

- **TypeScript 严格模式**：类型错误在生成阶段就暴露
- **Linting 强制执行**：ESLint/Ruff 配置提交前自动检查
- **测试先行（TDD-ish）**：让 AI 先写测试用例，再写实现，测试通过才算完成
- **Snapshot 测试**：UI 组件变化需要明确确认，防止 AI 悄悄改了样式

### 5. 基础设施层 — 安全网

- **Git 规范**：每个 AI 会话对应一个 feature branch，有问题直接 `git reset`
- **环境隔离**：开发/测试/生产严格分离，AI 只能操作开发环境
- **最小权限**：给 AI 工具只读数据库权限 + 文件系统白名单，防止误操作

---

## 三、工程化工作流示例

一个经过工程化的 Vibe Coding 工作流大致如下：
```
1. 写 Ticket（用户故事 + 验收标准）
         ↓
2. AI 读取 CLAUDE.md + Ticket，输出实现计划
         ↓
3. 人工确认计划（5分钟）
         ↓
4. AI 逐步生成代码，自动运行测试
         ↓
5. CI 流水线：Lint → Type Check → Test → Build
         ↓
6. 人工 Review Diff（10分钟）
         ↓
7. 合并 + 部署
````

---

## 四、选型推荐

|场景|推荐工具|
|---|---|
|命令行全栈开发|Claude Code|
|IDE 内辅助编码|Cursor + Rules 文件|
|快速原型|Bolt / Lovable|
|前端组件|v0 by Vercel|
|企业级工程流|GitHub Copilot + Actions|

---

**一句话总结**：Vibe Coding 工程化 = 用文档约束 AI 的行为范围 + 用自动化验证 AI 的输出质量 + 用 Git 保障人类的回滚能力。AI 负责执行，工程师负责定义边界和验收。

目前主流的企业级vibe coding 工程化解决方案有哪些？

3月24日

Searched the web

Searched the web

根据最新的市场数据，2026年企业级 Vibe Coding 的工具格局已经相当清晰，可以按**使用场景**分为三个层次。

---

## 一、开发者工具层（面向工程师）

这三个工具是目前企业工程团队的核心战场：

Created a file, read a file

Created a file, read a file

Log in to see interactive visuals

---

## 二、内部工具平台层（面向业务团队）

当企业需要让非工程师也能"vibe coding"，同时保证安全合规，这一层是关键：

**Retool / Clark (Superblocks)** — 业务团队可以不等工程师资源就直接构建内部应用，IT 通过集中的治理和审计日志保持完整可见性和控制权 [Superblocks](https://www.superblocks.com/blog/best-enterprise-vibe-coding-tools)。两者的核心价值是：自然语言生成应用的同时，自动套用企业的 RBAC、SSO、安全策略，消除"影子 IT"风险。

**传统低代码平台的局限**：Mendix、OutSystems、Microsoft PowerApps 等传统企业低代码平台提供了治理、安全和可扩展性，但它们建立在 AI 时代之前，缺乏自然语言应用生成和对话式开发能力。 [Retool](https://retool.com/blog/top-vibe-coding-tools)

---

## 三、工程服务层（外包 / 咨询）

对于没有内部 AI 能力的企业，Hexaware 等公司通过将 AI 原生开发与敏捷人工执行相结合，使用模块化 Vibe Coding 平台和智能代理来加速从 MVP 构建到遗留系统现代化的全过程，宣称可实现 10 倍交付速度、3 倍成本降低和 50% 更少缺陷。 [Hexaware Technologies](https://hexaware.com/blogs/is-vibe-coding-enterprise-ready-heres-what-tech-leaders-should-know/)

---

## 四、选型决策框架

|你的首要诉求|推荐方案|
|---|---|
|工程能力最强、复杂任务|**Claude Code** (Max 企业版)|
|工程师日常开发体验|**Cursor** (Business/Enterprise)|
|合规采购、Microsoft 生态|**GitHub Copilot Enterprise**|
|非工程师也能构建内部工具|**Retool / Superblocks Clark**|
|快速原型、前端优先|**v0 (Vercel) / Bolt / Lovable**|
|无内部 AI 团队、整体外包|**Hexaware / BairesDev 等服务商**|

---

## 五、2026 年的关键趋势

Andrej Karpathy 本人在 2026 年 2 月宣称 Vibe Coding "已经过时"，并提出了更结构化的"Agentic Engineering"范式 —— AI Agent 负责实现，人类提供架构设计和评审。 [Taskade](https://www.taskade.com/blog/state-of-vibe-coding-2026) 这正是企业级工程化的方向：从"AI 辅助"升级为"AI 主导执行 + 人类定义边界"。

约 45% 的 AI 生成代码包含需要人工审查的安全漏洞 [Synergylabs](https://www.synergylabs.co/blog/best-vibe-coding-platforms-2026-guide)，因此企业真正的竞争力不在于选哪个工具，而在于**建立围绕这些工具的工程约束体系** —— 规范、测试、审计、回滚机制缺一不可。

如果当前企业已经有一套成熟的开发框架，如何实施vibe coding

3月24日

这是企业落地 Vibe Coding 最核心的挑战：**不是从零开始，而是嫁接到已有的工程体系上。** 关键在于"最小侵入、渐进替换"。

---

## 一、现状诊断：先摸清"存量资产"

在引入任何 AI 工具之前，需要对现有框架做一次结构化盘点：

**代码资产**

- 代码库规模、语言/框架版本、模块化程度
- 有多少"只有老员工懂"的隐性知识？
- 测试覆盖率（这决定了 AI 改代码有没有安全网）

**流程资产**

- 现有 CI/CD 流水线是什么（Jenkins/GitLab CI/GitHub Actions）
- Code Review 流程是否规范化
- 需求到交付的链路有多长

**人员资产**

- 团队对 AI 工具的接受度
- 是否有人已经在私下用 Cursor/Claude

---

## 二、核心策略：把现有框架"喂给"AI

这是最关键的思路转变。不是让工程师去适应 AI，而是**把企业积累的工程知识编码成 AI 可读的上下文**。

### 第一步：构建项目级"AI 说明书"

在代码仓库根目录创建 `CLAUDE.md`（或 `.cursorrules`），把原来只存在于 Wiki、老员工脑子里、Review 评论里的隐性规范，显式化：

markdown

````markdown
# 项目工程规范（AI 上下文）

## 架构约定
- 采用 DDD 分层架构：Controller → Service → Repository → Domain
- 禁止跨层调用，Controller 不得直接操作 Repository
- 所有外部 API 调用必须封装在 Infrastructure 层

## 代码规范
- Java 17 + Spring Boot 3.x，禁止使用已废弃的 API
- 所有 Service 方法必须有对应的单元测试
- 数据库操作统一使用 MyBatis-Plus，禁止手写原生 SQL

## 命名约定
- 接口命名：XxxService（不加 I 前缀）
- DTO 命名：XxxRequest / XxxResponse
- 异常处理：统一抛出 BusinessException，不允许吞掉异常

## 禁止事项
- 不要修改 /core/framework 下的基础框架代码
- 不要引入新的 Maven 依赖，需先在 Slack #architecture 频道讨论
- 不要在代码里硬编码配置，统一走 Apollo 配置中心

## 当前技术债
- UserService 中有大量遗留代码，修改前先告知
- 支付模块正在重构，新功能不要在旧模块上加
```

这份文档的价值是：**让 AI 生成的代码天然符合你们的规范，而不是生成后再大量返工。**

---

## 三、实施路径：四个阶段渐进推进
```
阶段一        阶段二         阶段三          阶段四
个人工具  →  团队标准化  →  流程嵌入    →  规模化提效
(1-2周)      (1-2月)        (2-4月)         (持续)
```

### 阶段一：个人工具期（降低风险，积累经验）

选 2-3 个愿意尝试的工程师，在**新功能分支**上试用，不动主干。

重点验证：
- AI 生成的代码是否符合已有架构风格
- 哪类任务 AI 最省力（CRUD、单元测试、文档）
- 哪类任务 AI 反而添乱（复杂业务逻辑、性能敏感路径）

产出：一份内部使用报告，记录"哪些任务 AI 效率提升最明显"。

### 阶段二：团队标准化期（建立共识和规范）

把阶段一的经验转化为团队规范：

- **统一工具选型**：确定用 Cursor Business 还是 Claude Code Max，避免每人用不同工具导致结果不可预测
- **完善 CLAUDE.md**：基于真实 Review 反馈迭代，把 AI 常犯的错误加入约束
- **建立 Prompt 库**：把高频任务的 Prompt 模板沉淀到内部知识库（"为我们项目生成 CRUD 接口"的标准 Prompt）
- **明确边界**：哪些代码 AI 可以直接生成，哪些必须人工编写（核心鉴权、支付、数据迁移脚本）

### 阶段三：流程嵌入期（把 AI 编进研发流水线）

这是工程化最核心的一步——把 AI 从"个人习惯"变成"团队流程"：

**在需求阶段**，用 AI 生成技术方案草稿和接口契约，工程师做评审而非从零写；

**在开发阶段**，建立标准化的"AI 任务单"格式，确保 Prompt 包含足够的上下文约束：
```
任务：实现用户积分兑换接口
框架约束：参考 CLAUDE.md
接口规范：遵循现有 /api/v2/* 路由风格
数据库：users 表结构见 schema/users.sql
关联逻辑：需调用已有的 PointsService.deduct() 方法
测试要求：覆盖正常兑换、余额不足、商品下架三个场景
````

**在 Review 阶段**，在 PR 模板里加入"AI 生成代码"标记，触发额外的安全检查项；

**在 CI 阶段**，增加针对 AI 生成代码的检测（更严格的静态分析、依赖安全扫描）。

### 阶段四：规模化提效期（度量和优化）

建立可量化的效果追踪：

|指标|基线|目标|
|---|---|---|
|功能开发周期|X天|减少 30%|
|单测覆盖率|60%|提升到 80%（AI 帮写测试）|
|Code Review 轮次|平均 3 轮|降到 2 轮|
|Onboarding 时长|2周|1周（AI 帮理解代码库）|

---

## 四、最高风险点和对应措施

企业落地中最容易翻车的三个地方：

**1. AI 破坏了架构一致性**

症状：AI 生成的代码"能跑但不像我们的代码"，大量偏离架构规范。

根因：CLAUDE.md 写得不够具体，或者 AI 的上下文窗口没有覆盖到关键约束。

措施：在 CI 里加架构合规检查（ArchUnit for Java / dependency-cruiser for JS），让 AI 生成的架构违规在 CI 阶段就暴露。

**2. 测试覆盖不足导致 AI 改出 Bug**

症状：AI 重构了一段代码，看起来更整洁，但悄悄改变了边界行为。

根因：原有测试覆盖率低，没有安全网。

措施：**先提测试覆盖率，再开放 AI 重构权限**。让 AI 做的第一件事是补齐现有代码的单测，而不是改业务逻辑。

**3. 依赖引入失控**

症状：AI 为了解决一个小问题引入了一个新的第三方库。

措施：在 CLAUDE.md 里明确禁止引入新依赖，并在 CI 里加 `dependency-check`，新依赖出现时自动触发人工审批。

---

## 五、一句话总结

> 对已有成熟框架的企业，Vibe Coding 实施的本质是：**把工程师脑子里的规范显式化成 AI 可读的约束，把 AI 生成的代码纳入已有的质量门禁，渐进替换从确定性最高的任务开始。**

AI 不需要理解你们的业务，它只需要遵守你们的规范——而规范的质量，决定了 AI 输出的质量上限。

以bladex和saber3 为例，给出vibe coding 的实现路径

3月24日

Searched the web

Searched the web

好，BladeX + Saber3 是国内非常典型的企业级全栈框架组合。我对这个体系足够了解，可以给出非常具体的落地方案。

---

## 一、先摸清 BladeX + Saber3 的"规范资产"

在写 CLAUDE.md 之前，要把框架的隐性约定整理清楚：

**BladeX 后端的核心约定**

|层次|规范|关键类|
|---|---|---|
|响应封装|统一用 `R<T>` 返回|`R.success()` / `R.fail()`|
|基础实体|继承 `BaseEntity`|自动含 tenant_id、逻辑删除、时间戳|
|Service层|继承 `BaseServiceImpl`|内置多租户过滤|
|权限控制|注解 `@PreAuth`|`"hasAnyRole('admin')"`|
|查询构造|`Condition.getQueryWrapper()`|自动处理多租户|
|当前用户|`AuthUtil.getUser()`|含 tenantId、userId、roleName|
|包结构|`org.springblade.{模块}.{层}`|controller/service/mapper/entity/vo|

**Saber3 前端的核心约定**

|模式|规范|示例|
|---|---|---|
|列表页|avue-crud JSON驱动|option 配置列、表单、搜索|
|接口调用|axios 封装在 `api/` 目录|`getList / submit / remove`|
|路由权限|菜单绑定按钮权限码|`permission.js` 控制|
|状态管理|Vuex / Pinia|store 模块化|

---

## 二、CLAUDE.md：把 BladeX 规范喂给 AI

这是整个方案的核心文件，放在项目根目录。以下是**可直接使用**的完整版本：

markdown

````markdown
# BladeX + Saber3 项目 AI 开发规范

## 项目概述
- 后端：BladeX 4.x，Spring Boot 3.5，Spring Cloud 2025，MyBatis-Plus 3.x
- 前端：Saber3，Vue3，Element Plus，avue3
- 多租户 SaaS 平台，租户隔离是所有功能的前提

---

## 后端开发规范（BladeX）

### 包结构（严格遵守）
```
org.springblade.{模块名}/
  ├── controller/     # 仅做参数校验和响应封装
  ├── service/        # 接口定义
  │   └── impl/       # 业务实现，继承 BaseServiceImpl
  ├── mapper/         # 继承 BaseMapper<T>
  ├── entity/         # 继承 BaseEntity（禁止自定义 id/create_time 等基础字段）
  ├── vo/             # 视图对象，用于响应
  └── dto/            # 数据传输对象，用于请求参数
```

### 必须遵守的编码约定

**Controller 层**
- 返回值统一使用 `R<T>`，禁止裸返回实体
- 注解：`@RestController` + `@RequestMapping("/api/{版本}/{模块}")`
- 权限控制：使用 `@PreAuth("hasAnyRole('administrator')")` 或具体权限码
- 参数校验：使用 `@Valid` + `@NotBlank` 等 JSR-303 注解
- 分页：使用 `IPage<T>` + `Query` 对象，禁止自定义分页参数
```java
// 标准列表接口写法
@GetMapping("/list")
@PreAuth("hasAnyRole('administrator','{模块}:list')")
public R<IPage> list({Entity}VO vo, Query query) {
    IPage pages = {entity}Service.selectPage(Condition.getPage(query), vo);
    return R.data(pages);
}
```

**Service 层**
- 接口继承 `IService<T>`
- 实现类继承 `BaseServiceImpl<{Mapper}, {Entity}>`，禁止继承普通 ServiceImpl
- 复杂查询写在 Service 层，Mapper 只写 SQL

**Entity 层**
- 继承 `BaseEntity`（自动含：id、tenant_id、create_user、create_dept、
  create_time、update_user、update_time、status、is_deleted）
- 禁止在 Entity 里添加非数据库字段，非持久化字段放 VO
- 逻辑删除：框架已全局处理，不要手写 `is_deleted = 0` 的条件

**多租户规范（核心约束）**
- 查询条件使用 `Condition.getQueryWrapper(vo)` 而非 `new QueryWrapper<>()`，
  前者自动注入租户过滤
- 禁止在 SQL 里手写 `tenant_id` 条件，由框架自动处理
- 跨租户操作必须添加注释说明原因，并使用 `TenantContextHolder.ignore()`

**异常处理**
- 业务异常使用 `ServiceException` 抛出，框架统一捕获
- 禁止 `try-catch` 吞掉异常后返回 null

### MyBatis-Plus 规范
- 复杂 SQL 写在 Mapper.xml，简单 CRUD 用 MyBatis-Plus 注解
- 批量插入使用 `saveBatch()`，禁止循环单条 insert
- 不要使用 `@TableField(exist = false)` 在 Entity 上加业务字段，统一放 VO

---

## 前端开发规范（Saber3）

### 目录结构
```
src/
  ├── api/{模块}/index.js    # 接口定义
  ├── views/{模块}/          # 页面组件
  ├── store/modules/         # Pinia 状态模块
  └── router/                # 路由配置（权限路由由后端菜单驱动）
```

### avue-crud 标准写法（列表页必须使用此模式）
```javascript
// option 配置对象结构
const option = ref({
  // 表格配置
  searchShow: true,         // 显示搜索栏
  addBtn: true,             // 新增按钮
  editBtn: true,            // 编辑按钮
  delBtn: true,             // 删除按钮
  column: [
    {
      label: '字段名',
      prop: 'fieldName',
      search: true,          // 是否作为搜索条件
      rules: [{required: true, message: '请输入字段名'}]
    }
  ]
})
```

### API 文件规范
```javascript
// api/{模块}/index.js 固定结构
import request from '@/router/axios'
const BASE_URL = '/api/blade-{模块}'

export const getList = (current, size, params) =>
  request({ url: `${BASE_URL}/list`, method: 'get',
    params: { ...params, current, size } })

export const getDetail = (id) =>
  request({ url: `${BASE_URL}/detail`, method: 'get', params: { id } })

export const submit = (row) =>
  request({ url: `${BASE_URL}/submit`, method: 'post', data: row })

export const remove = (ids) =>
  request({ url: `${BASE_URL}/remove`, method: 'post',
    params: { ids } })
```

### 权限按钮规范
- 使用 `v-if="permission.{模块}_add"` 控制按钮显示
- 权限码命名：`{模块}_{操作}` （如 `order_add`、`order_delete`）

---

## 禁止事项（AI 生成代码必须规避）

### 后端
- ❌ 禁止使用 `new QueryWrapper<>()` 查询（用 `Condition.getQueryWrapper()`）
- ❌ 禁止修改 blade-core、blade-tool 等框架核心模块
- ❌ 禁止在 Entity 里写业务逻辑
- ❌ 禁止引入新的 Maven 依赖（需在 pom.xml 检查是否已有等价依赖）
- ❌ 禁止返回裸实体，必须转 VO
- ❌ 禁止 System.out.println，统一用 lombok @Slf4j + log.info

### 前端
- ❌ 禁止直接调用 axios，必须走封装好的 request 工具
- ❌ 禁止在 vue 文件里写内联样式（用 scss 模块）
- ❌ 禁止跳过 avue-crud，手写原生 el-table（除非产品设计有特殊要求）

---

## 当前项目状态说明
- blade-desk 模块：公告、待办功能，可参考此模块的代码风格
- blade-system 模块：用户、角色、菜单管理，多租户参考此模块
- 代码生成器：BladeX 内置代码生成，新模块先用生成器生成骨架再用 AI 完善
```

---

## 三、具体任务的 Prompt 模板

有了 CLAUDE.md，还需要针对 BladeX 开发中最高频的任务，建立标准化 Prompt。

### 任务1：生成一个新的业务模块（最高频）
```
请基于 BladeX 框架为【订单管理】模块生成完整的后端代码。

## 数据库表结构
```sql
CREATE TABLE blade_order (
  id          BIGINT       NOT NULL COMMENT '主键',
  tenant_id   VARCHAR(12)  NOT NULL COMMENT '租户ID',
  order_no    VARCHAR(32)  NOT NULL COMMENT '订单号',
  user_id     BIGINT       NOT NULL COMMENT '用户ID',
  amount      DECIMAL(10,2) NOT NULL COMMENT '订单金额',
  status      INT          DEFAULT 1 COMMENT '状态：1待支付 2已支付 3已取消',
  remark      VARCHAR(500) COMMENT '备注',
  create_time DATETIME     COMMENT '创建时间',
  create_user BIGINT       COMMENT '创建人',
  update_time DATETIME     COMMENT '更新时间',
  update_user BIGINT       COMMENT '更新人',
  is_deleted  INT          DEFAULT 0 COMMENT '逻辑删除'
) COMMENT='订单表';
```

## 要求
1. 严格遵守项目 CLAUDE.md 中的规范
2. 生成：OrderEntity / OrderVO / OrderController / OrderService / 
   OrderServiceImpl / OrderMapper / OrderMapper.xml
3. 接口包括：分页列表、新增、编辑、删除、详情
4. 多租户隔离：使用 Condition.getQueryWrapper()
5. 权限码：order:view / order:add / order:edit / order:delete
6. Controller 接口路径：/api/blade-order
```

### 任务2：生成 Saber3 前端列表页
```
请为【订单管理】生成 Saber3 前端页面。

## 后端接口（已生成）
- GET  /api/blade-order/list    分页列表，支持 order_no / status 搜索
- POST /api/blade-order/submit  新增/编辑
- POST /api/blade-order/remove  删除（ids 参数）
- GET  /api/blade-order/detail  详情

## 要求
1. 使用 avue-crud 组件驱动，不要手写 el-table
2. 生成：api/order/index.js + views/order/index.vue
3. 列表列：订单号、用户ID、金额、状态（字典翻译：待支付/已支付/已取消）、创建时间
4. 搜索条件：订单号（模糊）、状态（下拉）
5. 状态列使用 avue 字典配置，字典值：
   [{ label: '待支付', value: 1 },{ label: '已支付', value: 2 },{ label: '已取消', value: 3 }]
6. 权限按钮：v-if="permission.order_add" 等
```

### 任务3：补写单元测试（最容易被忽略但最有价值）
```
请为 OrderServiceImpl 中的以下方法补写单元测试：
- submitOrder()：测试正常下单、余额不足、商品不存在三个场景
- cancelOrder()：测试正常取消、已支付不可取消两个场景

## 要求
1. 使用 JUnit5 + Mockito
2. 遵循 BladeX 的 ServiceTest 基类写法
3. Mock 所有外部依赖（Mapper、外部 Service）
4. 每个测试方法名格式：should_{预期结果}_when_{条件}
```

---

## 四、与 BladeX 代码生成器协同

BladeX 内置了代码生成器，这是 Vibe Coding 的**天然起点**，正确的分工是：
```
代码生成器                    AI (Claude Code / Cursor)
──────────────────────────    ──────────────────────────
生成骨架代码                →  完善复杂业务逻辑
  Entity/VO/Controller           多步骤事务处理
  基础 CRUD 接口                 跨服务调用逻辑
  Mapper + XML                   业务规则校验
  前端 CRUD 页面             →  生成对应单元测试
                             →  补充 Swagger 注释
                             →  生成前端表单校验规则
                             →  生成接口联调文档
```

具体操作：在 BladeX 代码生成器里生成骨架后，用如下 Prompt 让 AI 接手：
```
以下是 BladeX 代码生成器生成的订单模块骨架代码：
[粘贴生成的代码]

请在此基础上完善以下业务逻辑：
1. submitOrder：需要扣减库存（调用 blade-product 服务的 StockService.deduct()），
   失败时回滚，使用 @Transactional
2. 订单号生成规则：yyyyMMdd + 6位序列号，用 RedisUtil.incr() 实现
3. 订单状态变更需要写入操作日志（调用已有的 LogService.record()）

严格遵守 CLAUDE.md 中的规范，不要修改生成器生成的基础结构。
````

---

## 五、CI 门禁：让 BladeX 规范自动检查

在 GitHub Actions 或 Jenkins 流水线里加入针对 BladeX 的特定检查：

yaml

```yaml
# .github/workflows/blade-check.yml（关键片段）

- name: 架构规范检查
  run: |
    # 检查是否有直接 new QueryWrapper（应使用 Condition.getQueryWrapper）
    if grep -r "new QueryWrapper" blade-service/ --include="*.java"; then
      echo "❌ 禁止直接 new QueryWrapper，请使用 Condition.getQueryWrapper()"
      exit 1
    fi
    # 检查 Controller 是否有裸返回实体（没有用 R<> 包装）
    if grep -r "return.*Entity()" blade-service/ --include="*Controller.java"; then
      echo "❌ Controller 禁止裸返回 Entity，请转换为 VO"
      exit 1
    fi
    # 检查 System.out.println
    if grep -r "System.out.println" blade-service/ --include="*.java"; then
      echo "❌ 禁止使用 System.out.println，使用 log.info()"
      exit 1
    fi

- name: 前端规范检查
  run: |
    # 检查是否有直接调用 axios（应走封装的 request）
    if grep -r "axios\." src/views/ --include="*.vue"; then
      echo "❌ 禁止在 views 里直接调用 axios"
      exit 1
    fi
```

---

## 六、落地节奏建议

对于已经在用 BladeX + Saber3 的团队，最务实的推进顺序是：

第一周，整理并完善 CLAUDE.md，把团队 Review 中最常打回的问题都写进去，这一步最关键，文档质量直接决定 AI 输出质量。

第二周，选一个中等复杂度的新需求（有 2-3 张关联表，有跨服务调用），完整跑通"生成器骨架 → AI 完善业务 → AI 补测试 → CI 检查 → Review"这条链路，记录哪些地方 AI 还需要人工干预。

第三到四周，把 AI 经常犯的错误补入 CLAUDE.md，同时把 CI 检查项逐步自动化，减少 Review 轮次。

一个月后，团队应能感受到：**CRUD 类需求基本不需要手写，工程师的精力集中到架构设计、业务规则判断和跨服务联调这些真正需要人脑的地方。**

这个框架自带了一个根据数据表生成一套crud基础代码，这个功能如何融入到vibe coding 中去，skill 还是 mcp,还是其他方法？

3月24日

这是一个非常好的工程化问题，答案涉及到三种方案的本质区别。先给出结论，再展开分析。

---

## 核心判断框架

```
问题的本质：代码生成器是一个「有状态的、依赖数据库连接的工具」

Skill（CLAUDE.md）→ 教 AI 模仿生成器的输出模式（静态知识）
MCP              → 让 AI 直接调用生成器本身（动态工具）
两阶段流水线      → 生成器跑完再交给 AI（手动协作）
```

**结论：MCP 是正确答案**，但需要分清哪部分走 MCP，哪部分走 Skill。

---

## 一、为什么不能只用 Skill？

Skill 本质是"告诉 AI 生成器会生成什么样的代码"，让 AI 模仿。但这有根本性缺陷：

AI 模仿的永远是**模式**，而生成器掌握的是**实际状态** —— 你的数据库里真实的字段类型、注释、索引，你的 pom.xml 里真实的版本，你已有的字典配置。这些动态信息 AI 不可能通过 Skill 感知到。

用 Skill 的结果是：AI 生成的代码和生成器的代码**风格类似但存在偏差**，反而制造了两套不一致的代码风格。

---

## 二、架构设计：MCP + Skill 各司其职

```
┌─────────────────────────────────────────────────────┐
│                   Claude Code / Cursor               │
├──────────────────┬──────────────────────────────────┤
│   Skill 层       │   MCP 工具层                       │
│  (CLAUDE.md)     │                                   │
│                  │  ┌─────────────────────────────┐ │
│  • 架构规范       │  │ bladex-mcp-server            │ │
│  • 禁止事项       │  │                             │ │
│  • 命名约定       │  │  tool: generate_crud        │ │
│  • 业务逻辑模板   │  │  tool: get_table_schema     │ │
│                  │  │  tool: get_dict_list        │ │
│                  │  │  tool: preview_code         │ │
│                  │  └─────────────────────────────┘ │
└──────────────────┴──────────────────────────────────┘
         │                        │
         ▼                        ▼
   AI 生成业务逻辑          BladeX 生成器 API
   AI 写测试用例            连接真实数据库
   AI 写前端复杂交互         读取真实表结构
```

---

## 三、BladeX MCP Server 实现

BladeX 的 `blade-develop` 模块暴露了代码生成的 REST 接口，把它包装成 MCP Server：

Created 4 files, viewed a file, ran a command

Created 4 files, viewed a file, ran a command

---

## 四、三种方案的最终定论

|方案|适合什么|不适合什么|
|---|---|---|
|**MCP**（推荐）|调用生成器、读取真实表结构、读取字典配置|静态的规范约束|
|**Skill（CLAUDE.md）**|编码规范、禁止事项、业务逻辑模板|任何需要读取真实状态的事情|
|**两阶段流水线**|团队无法维护 MCP Server 的过渡期|长期使用（手动协调成本高）|

---

## 五、接入后，AI 的实际工作流变成这样

```
用户说："帮我开发订单退款模块，表是 blade_refund_order"

AI 自动执行：
  1. [调用 bladex_get_table_schema]  ← 获取真实字段，不靠猜
        → 发现 refund_amount、refund_reason、audit_user 等字段

  2. [调用 bladex_get_dict("refund_status")]  ← 获取真实字典
        → { dicData: [{label:'待审核',value:1},{label:'已退款',value:2}...] }

  3. [调用 bladex_preview_code]  ← 展示将生成什么
        → "将生成 8 个文件，确认生成吗？"

  4. 用户确认后 [调用 bladex_generate_code]
        → 骨架代码落到磁盘

  5. AI 读取骨架，补充业务逻辑：
        → 退款需调用支付网关 RefundService.apply()
        → 审核通过后发 MQ 消息通知用户
        → 状态变更需记录操作日志

  6. AI 生成单元测试
```

**生成器负责保证风格一致，AI 负责处理生成器无法处理的业务复杂度。** 两者通过 MCP 无缝协作，不需要人工在中间传递文件。

那么整个项目或者模块的设计开发的流程是怎样的？从前端页面到后端数据库还是从后到前？

3月24日

这是 Vibe Coding 工程化里最值得深想的一个问题。答案不是"从前到后"或"从后到前"，而是**从中间开始** —— 以**数据契约**为锚点，双向展开。

---

## 一、为什么不能单纯"从后到前"或"从前到后"

传统后到前的问题：数据库设计好了才做前端，前端发现字段不够用，又改表，又重新生成，循环往复。

传统前到后的问题：前端原型漂亮，但和 BladeX 的多租户、BaseEntity 约定脱节，前端想要的结构后端生成器生不出来。

BladeX + Saber3 的特殊性在于：**代码生成器是以数据库表为驱动的**，这意味着表结构设计质量直接决定整个模块的代码质量。所以正确的流程是：

```
需求澄清 → 表结构设计（锚点）→ 后端骨架生成 → 业务逻辑 → 前端联调
               ↑
           所有人在这里对齐
```

---

## 二、完整流程全景图

```
┌─────────────────────────────────────────────────────────────────┐
│  阶段0：需求澄清（1-2小时）                                        │
│  输出：功能清单 + 核心数据实体 + 状态机草图                          │
└──────────────────────────┬──────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────────┐
│  阶段1：数据建模（锚点阶段）                                        │
│  AI辅助设计表结构 → 人工审核 → 执行DDL                              │
│  输出：blade_xxx.sql（符合BaseEntity约定的建表语句）                 │
└──────────────────────────┬──────────────────────────────────────┘
                           ↓
          ┌────────────────┴────────────────┐
          ↓                                 ↓
┌─────────────────────┐         ┌─────────────────────────┐
│  阶段2A：后端骨架     │         │  阶段2B：前端原型          │
│  MCP调用生成器        │         │  AI生成低保真页面结构       │
│  生成CRUD骨架         │         │  确认交互逻辑和字段映射     │
└──────────┬──────────┘         └────────────┬────────────┘
           ↓                                 ↓
┌─────────────────────┐         ┌─────────────────────────┐
│  阶段3A：业务逻辑     │         │  阶段3B：前端实现          │
│  AI补充复杂逻辑       │         │  基于确认的原型生成页面     │
│  AI生成单元测试       │         │  接入真实API              │
└──────────┬──────────┘         └────────────┬────────────┘
           └────────────────┬────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  阶段4：联调与收尾                                                 │
│  前后端联调 → AI辅助修复偏差 → 代码Review → 合并主干               │
└─────────────────────────────────────────────────────────────────┘
```

阶段2A和2B可以**并行**，这是 Vibe Coding 带来的关键提速点。

---

## 三、各阶段具体操作

### 阶段0：需求澄清

不要急着动键盘，先让 AI 帮你把需求结构化：

```
我需要开发一个【供应商管理】模块，功能包括：
供应商基本信息维护、资质证书上传、审核流程（待审核→审核中→已通过/已拒绝）、
关联采购合同查看

请帮我梳理：
1. 核心数据实体有哪些
2. 每个实体的关键属性
3. 实体之间的关系
4. 状态机（有状态流转的实体）
输出为结构化清单，不要写代码
```

AI 输出后，产品/开发一起确认，10-15分钟内对齐所有人的认知。

---

### 阶段1：数据建模（最关键的阶段）

这是整个流程的锚点，必须认真对待。

**用 AI 辅助设计 DDL，但人工做最终决策：**

```
基于上面确认的实体清单，请为【供应商管理】设计数据库表结构。

约束条件：
1. 必须继承 BladeX BaseEntity 约定：
   - 主键：id BIGINT（雪花算法，不自增）
   - 必含：tenant_id VARCHAR(12) COMMENT '租户ID'
   - 必含：create_user/create_dept/create_time/update_user/update_time
   - 必含：status INT DEFAULT 1 COMMENT '状态'
   - 必含：is_deleted INT DEFAULT 0 COMMENT '是否已删除'
2. 字段注释必须完整（代码生成器用注释生成表单label）
3. 状态字段使用整型，并在注释中说明每个值的含义
4. 关联字段存 ID，不存冗余数据（跨服务调用获取详情）
5. 避免宽表，超过20个字段考虑拆表

输出格式：可执行的 MySQL DDL
```

**人工审核的检查清单：**

- 索引是否合理（高频查询字段是否加索引）
- 字段类型是否合适（金额用 DECIMAL，不用 FLOAT）
- 状态值是否和业务字典对齐
- 表名是否符合 `blade_{模块}_{实体}` 命名规范

DDL 执行后，数据库里有了真实的表，后续 MCP 工具才能读取真实结构。

---

### 阶段2A：后端骨架生成（MCP驱动）

表结构确认后，在 Claude Code 里直接说：

```
blade_supplier 表已建好，请按以下配置生成代码骨架：
- packageName: org.springblade.supplier
- moduleName: supplier
- serviceId: blade-supplier

先预览，确认后再生成
```

Claude Code 自动调用 MCP 工具链：

1. `bladex_get_table_schema` 读取真实字段
2. `bladex_preview_code` 展示将生成的文件列表
3. 你确认后，`bladex_generate_code` 写入磁盘

骨架生成后，再用 AI 补充业务逻辑：

```
骨架已生成，请补充以下业务逻辑：

1. 审核流程（submitAudit方法）：
   - 状态只能从【待审核→审核中→已通过/已拒绝】单向流转
   - 非法状态流转抛出 ServiceException("当前状态不允许此操作")
   - 审核通过后，调用 blade-message 服务发送通知（用 Feign）

2. 资质证书有效期校验：
   - 每次查询时检查证书是否过期
   - 过期的供应商自动置为【资质过期】状态（status=4）

3. 在所有变更操作上加操作日志记录

请严格遵守 CLAUDE.md 中的 BladeX 规范
```

---

### 阶段2B：前端原型（与2A并行）

后端在生成骨架的同时，前端开发（或同一个人）用 AI 确认页面交互：

```
请为【供应商管理】设计 Saber3 前端页面结构（不要写完整代码，只确认设计）：

数据字段（来自已确认的表结构）：
- supplier_name（供应商名称）
- supplier_type（类型：1制造商 2代理商 3服务商）
- contact_name / contact_phone（联系人）
- audit_status（1待审核 2审核中 3已通过 4已拒绝 5资质过期）
- cert_expire_date（资质到期日）

请输出：
1. 列表页需要展示哪些列
2. 搜索条件有哪些
3. 表单分几个分组（基本信息/联系信息/资质信息）
4. 哪些操作需要权限控制
5. 特殊交互：audit_status为3才能查看合同
```

这一步很快（5分钟内），主要目的是在写代码前确认前端展示逻辑，避免前端写完发现字段对不上。

---

### 阶段3B：前端实现

原型确认后，让 AI 生成完整前端代码（此时生成器已经生成了基础骨架，在骨架上扩展）：

```
请在生成器生成的前端骨架上，完善以下内容：

1. 状态列用彩色 tag 展示：
   待审核=info，审核中=warning，已通过=success，已拒绝=danger，资质过期=info

2. 资质到期日距今<30天时，字体标红

3. 操作列按 audit_status 动态显示：
   - status=1：显示【提交审核】按钮
   - status=2（管理员）：显示【通过】【拒绝】按钮
   - status=3：显示【查看合同】按钮

4. 表单拆分三个 el-tab：
   - 基本信息（自动生成部分已有，微调）
   - 联系信息
   - 资质证书（含文件上传，用 avue 的 upload 组件）

从 bladex_get_dict 获取 supplier_type 字典，
不要硬编码字典值
```

---

### 阶段4：联调收尾

前后端代码都有了，开始联调。这个阶段 AI 主要做两件事：

**快速修复接口偏差：**

```
联调发现问题：
1. 前端 avue-crud 分页参数是 current/size，
   后端 Query 对象也是 current/size，但接口返回的分页数据
   结构是 {records, total, pages}，前端没有正确解析 total
   
请修复前端的 getList 方法中的响应解析逻辑
```

**生成联调文档：**

```
请基于已生成的 Controller 代码，
生成供前端使用的接口文档（Markdown格式），
包括：请求路径、方法、参数、响应示例
```

---

## 四、时间对比

同样一个中等复杂度模块（1个主表+1个明细表，含审核流程）：

|阶段|传统开发|Vibe Coding|
|---|---|---|
|需求澄清|半天开会|1小时（AI辅助结构化）|
|数据建模|2-4小时|30分钟（AI辅助+人工审核）|
|后端骨架|2-3小时|5分钟（MCP生成）|
|业务逻辑|1-2天|2-4小时（AI补充）|
|单元测试|半天~1天（经常被跳过）|1小时（AI生成）|
|前端实现|1-2天|3-5小时|
|联调|1天|半天|
|**合计**|**5-8天**|**1.5-2天**|

提速的核心不在于某个具体工具，而在于**数据建模作为锚点**消除了前后端反复对齐的摩擦，以及 MCP 工具链让"生成骨架"从几小时变成几分钟。

产品设计的原型图，应该放在vibe coding的哪个阶段？

3月24日

这个问题触到了 Vibe Coding 流程里一个真正的矛盾点：**原型图到底是输入还是输出？**

传统流程里原型图是开发的输入，但在 Vibe Coding 里，这个角色需要重新定义。

---

## 核心矛盾：原型图的定位之争

```
传统流程                          Vibe Coding 流程
─────────────────                ─────────────────────────────
需求 → 原型图 → 开发               需求 → ??? → AI生成 → ???
      ↑                                         ↑
   耗时最长                              速度极快，原型图
   的环节                                反而成了瓶颈
```

当 AI 可以在 10 分钟内生成一个可交互的页面，而原型图需要设计师花 2 天画出来，**原型图从"加速器"变成了"拦路虎"**。

但原型图承载的核心价值并没有消失，它只是需要换一种形态存在。

---

## 重新定义：原型图在不同阶段的角色

```
阶段              原型图的角色              形式
────────────────────────────────────────────────────────
需求澄清期         思考工具（非交付物）       草图/白板
数据建模期         字段验证工具              结构标注图
AI生成期           约束输入                  关键页面线框
联调验收期         验收基准                  高保真/可交互
```

原型图不是一个时间点的产物，而是**贯穿始终、形态递进**的东西。

---

## 具体的四种放置方案

### 方案A：原型图前置（传统做法，不推荐）

```
完整原型图 → 数据建模 → 生成器 → AI补充逻辑 → 前端实现
```

问题：设计师花3天画完整原型，AI 10分钟就能生成页面，大量原型细节（间距、颜色、动效）对 AI 毫无意义，浪费了最贵的人力。

### 方案B：草图前置 + 高保真后置（推荐）

```
草图(1小时) → 数据建模 → 生成器+AI → AI生成页面 → 高保真验收稿
   ↑                                      ↓
用于对齐字段                           用于确认交互对不对
和交互逻辑                             高保真在这里才有意义
```

关键思路：设计师在前期只需要出**低保真草图**，核心目的是对齐字段和核心交互，不需要像素级精确。高保真放到 AI 生成完页面骨架之后，**基于真实生成的界面做精修**，而不是凭空画。

### 方案C：用 AI 生成原型（激进做法）

直接跳过传统原型图：

```
需求文字描述 → AI生成可交互页面原型 → 产品/设计审查 → 确认后进入开发
```

用 v0、Lovable 等工具，产品经理直接用自然语言描述需求，AI 生成可点击的 HTML 原型，设计师在此基础上标注修改意见，开发直接接手。

适合：内部工具、中后台系统、需求变化频繁的场景。不适合：C端产品、有强品牌要求的场景。

### 方案D：原型图转结构化输入（最工程化的做法）

```
产品出原型图 → AI解析原型图提取结构 → 输出字段清单+交互规则 → 进入数据建模
```

把原型图作为 AI 的输入，而不是开发的输入。具体操作：

---

## 方案D的实操：原型图→结构化输入

把原型图截图发给 AI：

```
这是【供应商管理】模块的原型图截图。

请帮我从中提取：
1. 列表页展示的所有字段（字段名+数据类型推断）
2. 搜索条件列表
3. 表单字段及分组
4. 状态值及状态流转关系
5. 按钮及对应的操作权限

输出格式：用于下一步数据建模的结构化字段清单
不要写代码，只输出结构清单
```

AI 从原型图里"读"出结构信息，直接进入数据建模阶段，原型图从"人读的文档"变成了"AI可解析的输入"。

---

## 推荐的完整流程（BladeX + Saber3 场景）

```
Day 1 上午
  产品 + 开发 1小时对齐需求
  产品出核心页面草图（白板或纸稿，不用工具）
  AI解析草图，输出字段清单（方案D）
  ↓
Day 1 下午
  [锚点] 数据建模：AI辅助设计DDL，人工审核确认
  执行建表，表结构入库
  ↓
Day 2 上午
  后端：MCP调用生成器 → AI补充业务逻辑 → AI写测试
  前端：AI生成列表页骨架（并行）
  ↓
Day 2 下午
  设计师介入：基于AI已生成的真实页面出高保真稿
             （标注需要调整的地方，不是从零画）
  前后端联调
  ↓
Day 3
  根据高保真稿做UI还原
  测试验收
```

设计师的工作从"Day1开始画3天原型"变成了"Day2下午基于已有页面做1天精修"，总工时反而减少，且避免了原型和实现之间的偏差。

---

## 一句话总结

> 原型图在 Vibe Coding 里应该**一拆为二**：前期用最轻的草图对齐字段和交互逻辑（作为数据建模的输入），后期基于 AI 已生成的真实界面出高保真稿（作为验收基准）。把完整的高保真原型放在开发前是最大的浪费，因为 AI 生成的速度已经比高保真原型快了。

在上述流程中引入openspec，会有什么影响？

3月25日

这是一个会产生**结构性影响**的问题，不是简单地"加一个步骤"，而是引入了**第二个锚点**，从根本上改变了前后端的协作模式。

---

## 一、引入前后的本质差异

```
现有流程（单锚点）
─────────────────────────────────────────────────
需求 → [DDL 锚点] → 生成器 → 后端逻辑 → 前端实现
                                         ↑
                              前端依赖后端完成才能准确开发

引入 OpenAPI Spec 后（双锚点）
─────────────────────────────────────────────────
需求 → [DDL 锚点] → 生成器 → 后端逻辑
                 ↓
           [OpenAPI 锚点]
                 ↓
              前端实现（真正并行）
              Mock Server（不依赖真实后端）
              类型生成（TypeScript 类型安全）
              AI 精准生成（有完整契约）
```

DDL 解决了"存什么数据"，OpenAPI Spec 解决了"怎么传递数据"。两个锚点共同构成完整的技术契约，消除了前后端之间最大的沟通摩擦。

---

## 二、对各阶段的具体影响

### 数据建模之后，多出一个"契约设计"阶段

现在 BladeX 的 SpringDoc 会在服务启动后自动生成 OpenAPI Spec（`/v3/api-docs`），但这是**代码驱动生成**，时机偏晚。

引入 OpenAPI 的正确做法是把契约设计提前，在生成器跑完之后、前端动手之前，先把接口契约确定下来：

```
生成器生成骨架
     ↓
SpringDoc 自动输出 /v3/api-docs（JSON）
     ↓
AI 读取并审查契约完整性
     ↓
确认契约 → 前后端各自开工（真正并行）
```

这个阶段新增了一个操作：让 AI 检查生成的 OpenAPI Spec 是否完整：

```
BladeX 生成器已生成 blade-supplier 模块代码，
服务已启动，请读取 http://localhost:8888/blade-supplier/v3/api-docs

检查：
1. 所有 CRUD 接口是否都有完整的 requestBody 和 response schema
2. 分页接口的响应结构是否正确描述了 IPage<SupplierVO>
3. 枚举字段（audit_status）是否标注了可选值和含义
4. 认证头 Blade-Auth 是否在 securitySchemes 里定义

输出缺失项清单，我来补充 Swagger 注解后重新生成
```

### 前端开发方式发生根本变化

有了 OpenAPI Spec，前端不再需要等后端"接口好了来联调"，而是：

**第一步，生成 TypeScript 类型和 API Client：**

bash

```bash
# 用 openapi-typescript 生成类型
npx openapi-typescript http://localhost:8888/v3/api-docs -o src/types/api.d.ts

# 或者用 orval 生成完整的 API 请求函数
npx orval --config orval.config.ts
```

前端的 `api/supplier/index.js` 不再需要手写，直接从 Spec 生成，类型完全准确。

**第二步，启动 Mock Server：**

bash

````bash
# 用 prism 启动 mock 服务
npx @stoplight/prism-cli mock http://localhost:8888/v3/api-docs --port 4010
```

前端对着 Mock Server 开发，完全不依赖真实后端。Mock 数据从 Spec 的 example 字段自动生成。

**第三步，AI 生成前端代码时有了精准输入：**
```
请基于以下 OpenAPI Spec 片段生成 Saber3 的供应商列表页：

[粘贴或让 AI 读取 /v3/api-docs 中的 /supplier/list 接口定义]

不要猜测字段类型和接口结构，严格按 Spec 中的 schema 来，
SupplierVO 的 auditStatus 字段枚举值已在 Spec 中定义
````

AI 不再需要猜测接口返回结构，错误率大幅降低。

### 联调阶段变成"契约验证"而不是"对接口"

传统联调：前端说"你这个接口返回的字段名不对"，后端说"我没改啊"，来回扯皮。

引入 OpenAPI 后，联调阶段双方都对着 Spec 验证，出了问题直接看 Spec 是否被遵守：

bash

```bash
# 后端：用 schemathesis 验证真实接口是否符合 Spec
schemathesis run http://localhost:8888/v3/api-docs --checks all

# 前端：Prism 的 proxy 模式，请求真实后端但验证响应是否符合 Spec
npx @stoplight/prism-cli proxy http://localhost:8888/v3/api-docs http://localhost:8888 --port 4010
```

任何不符合契约的地方会直接报错，不再靠人肉排查。

---

## 三、需要新增的 MCP 工具

在现有 `bladex-mcp-server` 基础上，增加两个 OpenAPI 相关工具：

javascript

````javascript
// 工具：获取服务的 OpenAPI Spec
{
  name: 'get_openapi_spec',
  description: '获取指定 BladeX 微服务的 OpenAPI Spec（JSON格式），用于生成前端代码或验证接口契约',
  inputSchema: {
    type: 'object',
    properties: {
      serviceId: {
        type: 'string',
        description: '微服务名称，如 blade-supplier'
      },
      path: {
        type: 'string',
        description: '只获取特定路径的接口定义，如 /supplier/list',
        required: false
      }
    }
  }
},

// 工具：验证接口实现是否符合 Spec
{
  name: 'validate_api_contract',
  description: '调用 schemathesis 验证真实运行的接口是否符合 OpenAPI Spec，返回不符合项清单',
  inputSchema: {
    type: 'object',
    properties: {
      serviceId: { type: 'string' },
      endpoint: {
        type: 'string',
        description: '只验证特定接口，不传则验证全部'
      }
    }
  }
}
```

---

## 四、更新后的完整流程
```
Day 1 上午
  需求澄清 + 草图
  AI 解析草图 → 字段清单
  ↓
  [锚点1：DDL]
  AI 辅助设计建表语句 → 人工审核 → 执行
  ↓
Day 1 下午
  MCP 调用生成器 → 后端 CRUD 骨架落盘
  启动服务
  ↓
  [锚点2：OpenAPI Spec]
  SpringDoc 自动生成 Spec
  AI 检查 Spec 完整性 → 补充 Swagger 注解 → 确认契约
  ↓
  ── 后端 ──────────────────── 前端 ──────────────
  AI 补充业务逻辑          从 Spec 生成 TS 类型
  AI 写单元测试            启动 Mock Server
                           AI 基于 Spec 生成页面
  ─────────────────────────────────────────────────
  ↓
Day 2
  后端：业务逻辑完成，接口可用
  前端：页面骨架完成，对接真实后端
  联调：schemathesis 验证契约合规性
  ↓
  设计师基于真实页面出高保真稿
  根据高保真稿做 UI 还原
````

---

## 五、一句话总结

> 引入 OpenAPI Spec 的本质是在 DDL 之后建立**第二个机器可读的锚点**，把前后端从"串行等待"变成"并行开发"，同时让 AI 生成前端代码时从"猜结构"变成"读契约"，把联调从"人肉对接"变成"自动化验证"。代价是多了一个"契约审查"的步骤，但这个步骤消除了整个后续流程里最大的不确定性。

不是，我指的openspec是类似spec-kit的工具

3月25日

Searched the web

Searched the web

明白了，这是 GitHub 开源的 Spec-Kit，实现的是 **Spec-Driven Development（SDD）** —— 规格驱动开发。这个问题问得很深，因为 SDD 和我们之前讨论的流程之间存在**根本性的哲学冲突**，引入它不是"加一个步骤"，而是**重新定义谁是第一公民**。

---

## 一、冲突的本质

```
现有流程的第一公民      SDD 的第一公民
─────────────────      ─────────────────
代码（DDL + 生成器）     Spec（规格文档）

"表设计好了，代码跟着走"   "Spec 定义好了，DDL 和代码都是它的输出"
```

在 SDD 的世界里，规格是主要制品，代码是它在特定语言和框架中的表达。维护软件意味着演进规格，而不是直接改代码。 [GitHub](https://github.com/github/spec-kit/blob/main/spec-driven.md) 这对 BladeX 这类以生成器为核心的框架来说，意味着**工作流的倒置**。

---

## 二、Spec-Kit 的核心工作流

Spec-Kit 提供了一套结构化的开发命令：`/specify` 描述要构建什么，`/clarify` 让 AI 提出针对性问题，`/plan` 生成技术方案，`/tasks` 分解任务，`/implement` 执行实现。 [Speckit](https://speckit.org/)

还有一个经常被忽视的关键命令：`/constitution` —— 这是项目的高层原则集合，定义了开发团队对代码构建方式的要求，例如确保代码经过测试、针对性能优化等。可以把它理解为团队现有架构标准的编码化。 [InfoWorld](https://www.infoworld.com/article/4062524/spec-driven-ai-coding-with-githubs-spec-kit.html)

这五个命令对应的产物：

```
/constitution  →  项目宪法（不变的工程约束）
/specify       →  功能规格（这次要做什么）
/clarify       →  澄清清单（AI 问你补充信息）
/plan          →  技术方案（如何实现）
/tasks         →  任务拆解（分步执行）
/implement     →  代码生成（最后才写代码）
```

---

## 三、引入后对 BladeX 流程的具体影响

### 影响1：原型图找到了明确的归宿

上一个问题没有完全答清楚的部分，在这里有了答案。

原型图的正确处理方式是作为 `/specify` 的输入：

```
产品出草图
    ↓
把草图截图 + 需求描述 → 执行 /specify
    ↓
AI 生成结构化 Spec（用户故事 + 验收标准 + 数据实体清单）
    ↓
/clarify 补充边界条件
    ↓
Spec 确认 → 进入数据建模
```

原型图从"给开发看的文档"变成了"给 AI 解析的输入"，Spec 才是真正传递给后续所有环节的东西。

### 影响2：DDL 设计有了更完整的上下文

现在的流程是直接从需求跳到 DDL，设计者脑子里的业务理解没有被显式记录下来。

引入 Spec 后，DDL 设计变成了 Spec 的一个**推导结果**：

```
/specify 生成的 Spec 包含：
  - 核心实体：供应商、资质证书、审核记录
  - 业务规则：证书过期自动变更状态
  - 约束条件：同一供应商不能有两条待审核记录

AI 读取 Spec → 推导 DDL：
  - blade_supplier（主表）
  - blade_supplier_cert（证书表，1对多）
  - blade_supplier_audit_log（审核日志，不可删除）
```

DDL 设计的依据从"凭经验"变成了"从 Spec 推导"，可以被追溯和审查。

### 影响3：CLAUDE.md 的定位发生变化

现在 CLAUDE.md 承担了两类职责：一类是项目级工程约束（框架规范、禁止事项），另一类是每次任务的上下文（这个模块要做什么）。

引入 Spec-Kit 后，职责拆开：

```
/constitution → 生成项目宪法文件
                等价于 CLAUDE.md 中的工程规范部分
                一次写好，长期有效

/specify 生成的 Spec → 每次任务的上下文
                        替代原来在 Prompt 里临时写的需求描述
```

CLAUDE.md 变薄，专注于 BladeX 框架约定；Spec 文件承载业务需求，两者职责清晰。

### 影响4：生成器的触发时机后移

现在的流程是 DDL 确认就立刻调用生成器。引入 SDD 后，生成器触发时机变成：

```
Spec 确认
    ↓
/plan 生成技术方案（此时 AI 知道需要哪些表）
    ↓
/tasks 拆解任务（任务1：设计DDL，任务2：调用生成器，任务3：补充业务逻辑...）
    ↓
/implement 执行任务1 → AI 辅助设计 DDL → 人工审核
    ↓
/implement 执行任务2 → MCP 调用 BladeX 生成器
    ↓
/implement 执行任务3 → AI 补充业务逻辑（参照 Spec 中的验收标准）
```

生成器从"拿到表就跑"变成了"执行任务计划的一个步骤"，上下文更完整。

---

## 四、更新后的完整流程

```
─── 规格阶段（新增）──────────────────────────────────────
  
  产品草图 + 需求描述
       ↓
  specify init（初始化项目，绑定 Claude Code）
       ↓
  /constitution（写入 BladeX 工程约束 + 业务合规要求）
       ↓
  /specify（AI 生成功能规格，含实体清单和业务规则）
       ↓
  /clarify（补充边界条件，如并发场景、权限边界）
       ↓
  Spec 文件确认（产品 + 开发 + 测试三方对齐）

─── 设计阶段（原锚点，现在有 Spec 支撑）───────────────────

  /plan（AI 读取 Spec，生成技术方案含 DDL 草稿）
       ↓
  人工审核 DDL → 执行建表

─── 实现阶段（并行，Spec 作为验收基准）────────────────────

  /tasks（AI 生成任务列表）
       ↓
  后端任务：                    前端任务：
  MCP 调用生成器               AI 基于 Spec 生成页面结构
  AI 补充业务逻辑               设计师基于 Spec 出高保真稿
  每个任务完成后对照 Spec 验收   联调时以 Spec 为裁判

─── 演进阶段（SDD 最大的价值）─────────────────────────────

  需求变更 → 先改 Spec → AI 分析影响范围 → 定向regenerate
  而不是：需求变更 → 直接改代码 → Spec 和代码开始漂移
```

---

## 五、真正的风险：Spec 质量决定一切

SDD 最大的挑战不是 AI，而是人。它要求开发者精确地描述意图，但这恰恰是最难的部分。在超过10年的软件开发经验中，很少见到需求在实现前被完整描述清楚的项目。 [Medium](https://danielsogl.medium.com/spec-driven-development-sdd-the-evolution-beyond-vibe-coding-1e431ae7d47b)

即使有了所有这些文件、模板、提示和工作流，AI 经常仍然不能遵循所有的指令。上下文窗口变大了，但窗口变大不意味着 AI 会正确地吸收其中的所有内容。 [Martin Fowler](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)

对 BladeX 团队来说，这意味着两个实际建议：

第一，**不要对小任务用 SDD**。一个 3-5 天的普通 CRUD 模块，直接走 DDL → 生成器 → AI 补逻辑的路径更快。SDD 适合**跨团队协作、需求复杂、需要长期演进**的核心模块。

第二，**Spec 写作能力需要培养**。/constitution 是一次性投入，写好了长期受益。/specify 的质量取决于产品经理和架构师的参与深度，不能完全甩给 AI 自己生成。

---

## 六、一句话总结

> Spec-Kit 把原型图、需求文档、架构决策统一成一个**机器可读、版本可控、可演进的 Spec 文件**，让 DDL 和代码都成为 Spec 的推导结果而不是起点。对 BladeX 团队，它的最大价值不在于加速单个功能的开发，而在于**让需求变更不再直接冲击代码，而是先冲击 Spec，再由 Spec 定向驱动变更**。

SDD 对vibe coding工程化有哪些影响，利大于弊还是弊大于利？

3月25日

这是一个值得认真对待的问题，不能给一个简单的"利大于弊"结论，因为**答案取决于你在哪个维度上衡量，以及你的团队处于什么阶段**。

我先给结论，再展开论证。

---

## 结论

```
对 Vibe Coding 工程化而言：

SDD 是一剂正确的药，但剂量和时机都很关键。

用对了 → 从"快但乱"变成"快且稳"
用错了 → 从"快但乱"变成"慢且更乱"
```

---

## 一、SDD 解决的根本问题

要判断利弊，先要清楚 SDD 针对的是什么。

Vibe Coding 工程化面临一个内在矛盾：

```
AI 的生成速度          ↑↑↑  越来越快
人类对齐需求的速度      →    没有本质变化
─────────────────────────────────────────
差距越来越大，代码生产速度超过了人类消化需求的速度
结果：堆积的是代码，而不是价值
```

如果不提前决定要构建什么以及为什么要构建，代码库就会成为事实上的规格说明——一堆看似不相关的组件，可以协同工作但难以维护、演进和调试。代码本质上是一种约束性制品，一旦写出实现，就很难与之解耦。 [Microsoft Developer](https://developer.microsoft.com/blog/spec-driven-development-spec-kit)

SDD 试图在 AI 生成代码之前，先把"人类对齐"这件事做到位。这个出发点是正确的。

---

## 二、SDD 带来的真实收益

### 收益1：需求漂移问题从根本上被遏制

没有 Spec 的 Vibe Coding 是这样的：

```
第1天："做一个供应商管理"
第3天："哦对，需要审核流程"
第5天："审核要分两级"
第7天："其实三级更合理"
每次变更 → AI 重新生成 → 和之前的代码产生摩擦
```

有了 Spec 之后：

```
变更 → 先改 Spec → AI 分析影响范围 → 定向修改
变更有了成本感知，产品经理在改 Spec 之前会三思
```

SDD 将需求变更从障碍转变为正常工作流。当规格驱动实现时，变更成为系统性的重新生成，而不是手动重写。 [GitHub](https://github.com/github/spec-kit/blob/main/spec-driven.md)

### 收益2：AI 生成质量的上限被拉高

这是被低估的核心收益。

AI 生成代码质量的瓶颈从来不是模型能力，而是上下文的完整度：

```
Prompt 质量 ──────────────────────────────────→ 代码质量
"做一个供应商管理"          →  通用骨架，需大量返工
"做供应商管理，有这些字段"   →  基本可用
Spec 文件（完整）           →  接近直接可用
```

Spec-Kit 的核心洞察是：问题不在于 AI 的编码能力，而在于我们的工作方式。我们一直把 AI 当搜索引擎用，而不是当谨慎的合作伙伴。模型擅长模式识别，但仍然需要明确的指令。简而言之，缺乏上下文才是问题所在。 [IntuitionLabs](https://intuitionlabs.ai/articles/spec-driven-development-spec-kit)

### 收益3：跨角色协作有了共同语言

```
传统团队对齐成本：
  产品写 PRD（Word）→ 开发理解（有偏差）→ 设计出图（有偏差）
  → 测试写用例（再次偏差）→ 联调发现问题

SDD 之后：
  Spec 是唯一真相来源
  产品、开发、测试都从同一份 Spec 工作
  AI 也从同一份 Spec 生成代码和测试用例
```

当做对了，设计师、前端、后端和产品经理都从同一份规格中获取功能行为，避免了"我以为你是这个意思"的经典问题在冲刺中途出现。 [IntuitionLabs](https://intuitionlabs.ai/articles/spec-driven-development-spec-kit)

### 收益4：技术债务的累积速度被减慢

没有 Spec 的 Vibe Coding 会产生一种特殊的技术债：**意图债**。代码在那里，但为什么这样写、当时的业务约束是什么，没有任何记录。

规格成为共同的真相来源。当有什么不对劲时，回到规格；当项目变得复杂时，精炼它；当任务感觉太大时，分解它。 [GitHub](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/) 这种活文档的价值在项目运行 6 个月后才会真正显现。

---

## 三、SDD 带来的真实代价

### 代价1：前期投入显著增加

这是最直接的弊端，不能回避。

规格驱动开发没有 Vibe Coding 那么快，但这不是重点。 [InfoWorld](https://www.infoworld.com/article/4062524/spec-driven-ai-coding-with-githubs-spec-kit.html)

具体来说，一个中等模块：

```
纯 Vibe Coding：
  需求 → 动手 → 完成（1.5天）

SDD + Vibe Coding：
  /constitution（一次性，1小时）
  /specify（30-60分钟）
  /clarify（20-30分钟）
  /plan（20分钟）
  /tasks（10分钟）
  → 动手（1天）
  合计约 2.5 天
```

前期多了将近 1 天的"写文档"时间。对于短平快的项目，这个代价是不可接受的。

### 代价2：Spec 质量完全依赖人的能力

这是 SDD 最根本的弱点。

SDD 面临的根本挑战不是 AI，而是人。它要求开发者精确描述意图，而这恰恰是最难的。在超过10年的软件开发中，很少见到需求在实现前被完整描述的项目。 [Medium](https://danielsogl.medium.com/spec-driven-development-sdd-the-evolution-beyond-vibe-coding-1e431ae7d47b)

如果 Spec 写得模糊，SDD 的效果甚至不如直接 Vibe Coding——因为模糊的 Spec 会给 AI 一种"已经有上下文了"的错觉，实际上误导了生成方向。

### 代价3：AI 并不总是忠实执行 Spec

这是工具层面的现实限制。

即使有了所有这些文件、模板、提示和工作流，AI 经常仍然不能遵循所有的指令。上下文窗口变大了，但窗口变大不意味着 AI 会正确地吸收其中的所有内容。AI 在研究阶段仔细研究了现有代码，但最终忽略了这些是现有类的描述，把它们当成新的规格重新生成了，造成了重复。 [Martin Fowler](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)

Spec 越长，AI 遗漏关键约束的概率越高。这意味着你需要把 Spec 切成足够小的片段，本身又增加了管理成本。

### 代价4：对 BladeX 生成器的工作流有摩擦

这是针对我们具体场景的特殊问题。

BladeX 的生成器是**表结构驱动**的，它的工作起点是 DDL，不是 Spec。SDD 的工作起点是 Spec，DDL 是推导结果。

两者之间有一个尴尬的衔接：

```
Spec 描述："供应商有基本信息和资质证书"
     ↓
AI 推导出需要两张表
     ↓
生成 DDL（需要人工审核确认）
     ↓
执行 DDL
     ↓
MCP 调用生成器
```

这个链条是通的，但每一个箭头都是一个需要人工介入的节点。Spec-Kit 本身不理解 BladeX 的 BaseEntity 约定，生成的 DDL 草稿需要人工修正才能符合框架规范。

---

## 四、利弊的决定因素

不是 SDD 本身决定利弊，而是**你在哪个场景下用它**。

```
场景                           建议
──────────────────────────────────────────────────────
新功能，需求清晰，1-3天能完成    ❌ 不用 SDD，直接 Vibe Coding
新功能，需求模糊，多方对齐困难   ✅ 用 SDD，Spec 过程就是对齐过程
核心模块，长期维护，多人协作     ✅ 强烈推荐 SDD
遗留系统改造，技术债清理         ✅ 用 SDD 重新定义意图
探索性原型，快速验证想法         ❌ 不用 SDD，速度第一
紧急修复，线上问题               ❌ 完全不用 SDD
```

---

## 五、在 BladeX 体系里的最优组合

不是"用 SDD"还是"不用 SDD"的二选一，而是**分层使用**：

```
项目级（用一次）
  /constitution → 写入 BladeX 规范 + 业务合规要求
  等价于 CLAUDE.md，但更结构化，AI 理解更好
        ↓
核心模块（按需）
  /specify + /clarify + /plan → 生成模块 Spec
  适用于：复杂业务模块、跨服务模块、核心数据模型
        ↓
普通模块（跳过 Spec）
  直接 DDL → MCP 生成器 → AI 补逻辑
  适用于：标准 CRUD、简单配置模块
        ↓
任务级（每次都用）
  /tasks → 把模块拆成具体任务再实现
  这一步成本最低，收益最高，几乎没有理由跳过
```

**`/tasks` 这一步是 SDD 里性价比最高的单个命令**，即使你跳过了 /specify 和 /plan，把一个模块拆成明确的小任务再让 AI 执行，质量也会比一口气让 AI 生成整个模块高得多。

---

## 六、最终判断

```
维度                  结论
──────────────────────────────────────────────────
代码质量上限           SDD 更高（上下文更完整）
短期开发速度           纯 Vibe Coding 更快
长期维护速度           SDD 更快（Spec 是活文档）
需求对齐效果           SDD 显著更好
团队协作效率           SDD 更好（统一语言）
工具链成熟度           SDD 尚未成熟（AI 执行不稳定）
学习曲线               SDD 更陡（需要写 Spec 的能力）
```

**综合判断：利大于弊，但前提是用在正确的场景上。**

对于 BladeX 这类框架驱动的企业项目，最务实的建议是：**把 SDD 的 `/constitution` 和 `/tasks` 作为标配，把 `/specify` 作为复杂模块的选配**，而不是对所有任务强制走完整的 SDD 流程。SDD 的价值不在于替代 Vibe Coding，而在于给 Vibe Coding 装上一个**在需要的时候能刹车的系统**。

具体的SDD工具有哪些？

3月28日

Searched the web

Searched the web

现在有了足够完整的信息。SDD 工具生态在 2025-2026 年爆发式增长，但工具之间哲学差异很大，需要按**成熟度维度**来理解。

---

## 一、先看全貌

SDD 有三个成熟度层次：Spec-First（写完 Spec 就不管了）、Spec-Anchored（Spec 和代码长期共存）、Spec-as-Source（Spec 是唯一维护制品，代码是生成产物）。 [Martin Fowler](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html) 不同工具处于不同层次，选错层次比选错工具更致命。

```
Spec-First        Spec-Anchored        Spec-as-Source
────────────      ─────────────        ──────────────
OpenSpec          GitHub Spec-Kit      Tessl
GSD               AWS Kiro             （实验阶段）
                  BMAD-METHOD
                  Claude Code Skills
                  Intent (Augment)
```

---

## 二、主流工具逐一解析

### 1. GitHub Spec-Kit

**定位：结构化流程脚手架，开源 CLI**

工作流分四个阶段：`/specify` 从描述生成详细规格，`/plan` 在给定技术栈约束下创建实现计划，`/tasks` 将计划拆解成小的可审查任务块，AI Agent 顺序实现每个任务。通过"宪法基础"强制执行架构规则。 [DEV Community](https://dev.to/bobbyblaine/spec-driven-development-write-the-spec-not-the-code-2p5o)

适合场景：**新项目全流程，有明确技术架构，团队需要标准化流程**

主要缺陷：对大型已有代码库基本无法使用；随着应用增长，Spec 越来越偏离实际。 [Marmelab](https://marmelab.com/blog/2025/11/12/spec-driven-development-waterfall-strikes-back.html)

---

### 2. AWS Kiro

**定位：原生 SDD 的 IDE，VS Code 内核**

AWS Kiro 是企业平台，采用三阶段工作流：Specify → Plan → Execute。对 AWS 深度集成，对已有代码库支持较强。 [SoftwareSeni](https://www.softwareseni.com/spec-driven-development-in-2025-the-complete-guide-to-using-ai-to-write-production-code/)

Kiro 将规格驱动开发置于核心：你写高层需求 → 用户故事 → 验收标准，Kiro 帮助生成技术设计并将工作拆成实现任务，支持"钩子"机制——由文件变更或提交触发的事件驱动 Agent。 [Medium](https://medium.com/@visrow/comprehensive-guide-to-spec-driven-development-kiro-github-spec-kit-and-bmad-method-5d28ff61b9b1)

适合场景：**AWS 技术栈，中大型团队，需要 IDE 内原生支持**

主要缺陷：Kiro 生成的 Spec 可能冗长，带有不必要的假设需要手动修剪；Spec 和代码可能失去同步，尚未完全自动化双向协调。 [Rushi's](https://www.rushis.com/spec-driven-development-sdd-a-technical-deep-dive-into-the-methodologies-reshaping-ai-assisted-engineering/)

---

### 3. BMAD-METHOD

**定位：多 Agent 模拟完整敏捷团队，开源**

BMAD 为不同职能分配命名 Agent：Mary（业务分析师）负责需求，Preston（产品经理）负责 PRD，Winston（架构师）负责系统设计，Sally（产品负责人）负责 Story 精化，Simon（Scrum Master）负责协调，Devon（开发者）负责实现，Quinn（QA 工程师）负责测试策略。 [Augment Code](https://www.augmentcode.com/tools/best-spec-driven-development-tools)

Spec-Kit 和 OpenSpec 更像工具，专注于"如何写好提示词"；BMAD 是框架，专注于"如何组织 AI 团队"。对企业级开发，BMAD 的结构性优势极为明显。 [Redreamality's Blog](https://redreamality.com/garden/notes/bmad-method-guide/)

安装：

bash

````bash
npx bmad-method install
```

适合场景：**复杂绿地项目，需要完整 SDLC 覆盖，大型团队，合规审计要求**

主要缺陷：学习曲线最陡；上下文过载时 LLM 会忽略指令；Agent 之间的角色越界问题需要严格管理。 

---

### 4. OpenSpec
**定位：轻量级增量变更管理，专为存量代码库设计**

OpenSpec 的关键架构创新是将"当前已实现的真相来源"与"提议的变更（Delta）"分离。每个功能请求或 Bug 修复成为 `changes/` 目录下的独立子文件夹，包含 `proposal.md`、`specs/`、`design.md` 和 `tasks.md`。`AGENTS.md` 文件（"给机器人的 README"）让任何 AI 工具即使没有原生支持也能通过读取这个文件来遵循 Spec。 

适合场景：**存量代码库的迭代维护，需要变更可追溯，轻量导入**

主要缺陷：约束少意味着团队自律要求高；大型系统的单一 Spec 文档可能变得难以管理。

---

### 5. Tessl
**定位：Spec-as-Source 的激进实践，代码完全由 Spec 生成**

Tessl 框架让团队在开始编码前定义要构建的内容，使用精心制作的规格（Spec）或 AI 生成的"vibe-spec"。这些说明作为长期记忆存在于代码库中，引导 Agent 随应用演进，并与测试配对来强制执行护栏，确保现有功能不被破坏。 

代码文件顶部甚至会标注注释：`// GENERATED FROM SPEC - DO NOT EDIT`。 

适合场景：**实验性项目，探索 Spec-as-Source 极限，目前仍在 Beta**

主要缺陷：最激进，工程成熟度最低，生产环境风险最大。

---

### 6. Claude Code Skills
**定位：可复用的 Slash 命令，轻量级 SDD 补丁**

Claude Code Skills 是可复用的 Slash 命令，编码可重复工作流。它们充当轻量级规格——定义 Claude Code 对常见任务应该做什么，如生成组件、运行测试套件或创建 API 端点。 

这是接入成本最低的方案，不需要改变现有工作流，只是给 Claude Code 装上"领域专用命令"。对 BladeX 团队最实用。

---

### 7. Intent（Augment Code）
**定位：Living Spec——Spec 与代码实时同步**

在一次跨四个微服务的重构中，Living Spec 追踪了哪些服务已更新、哪些接口已变更、哪些下游消费者需要修改。当 Implement Agent 改变了某个服务的 API 响应结构，Spec 立即反映了这个变化，后续 Agent 在处理消费者服务时引用的是更新后的契约，而不是原始版本。 

这是目前解决"Spec 与代码漂移"问题最激进的商业化尝试。

---

## 三、选型矩阵
```
                    绿地项目    存量代码库   团队规模    合规要求
─────────────────────────────────────────────────────────────
GitHub Spec-Kit       ✅✅        ❌          中小        中
AWS Kiro              ✅✅        ✅          中大        高（AWS）
BMAD-METHOD           ✅✅        ✅          中大        高
OpenSpec              ✅          ✅✅        小中        低
Tessl                 ✅          ❌          小          实验
Claude Code Skills    ✅          ✅          任意        低（轻量）
Intent/Augment        ✅          ✅✅        大          高
```

---

## 四、对 BladeX 项目的具体推荐

结合之前讨论的 BladeX + Saber3 场景，最务实的组合是：

**第一优先：Claude Code Skills + OpenSpec**
```
Claude Code Skills → 封装 BladeX 特定的开发命令
                     /bladex:new-module（调用 MCP 生成器）
                     /bladex:add-business-logic
                     /bladex:gen-test

OpenSpec          → 管理每次需求变更的 Delta
                     changes/supplier-audit/proposal.md
                     changes/supplier-audit/tasks.md
````

这个组合接入成本最低（不改变现有工作流），但能获得 SDD 最核心的收益：变更可追溯 + AI 有明确上下文。

**复杂模块升级：BMAD-METHOD**

当面对跨多个微服务的复杂新模块（如重新设计整个供应链模块），引入 BMAD 的 Analyst + Architect + Developer 三角，用结构化的多 Agent 协作替代单一 Prompt。

---

## 五、一张图总结

三种工具就像三种工程图纸的选择：OpenSpec 是针对小型管道维修的定向修复图；Spec-Kit 是为明确定义的新房子准备的蓝图；BMAD 是为摩天大楼模拟施工全过程的完整工程公司。 [Medium](https://medium.com/@ap3617180/steering-the-agentic-future-a-technical-deep-dive-into-bmad-spec-kit-and-openspec-in-the-sdd-4f425f1f8d2b)

选哪个，取决于你要建什么，而不是哪个工具最"先进"。

[https://github.com/obra/superpowers](https://github.com/obra/superpowers) 这个工具是不是SDD工具？

3月28日

Fetched: GitHub - obra/superpowers: An agentic skills framework & software development methodology that works.

Fetched: GitHub - obra/superpowers: An agentic skills framework & software development methodology that works.

读完 README 之后，答案是：**不是，但它和 SDD 有一个重要的交叉点，需要仔细区分。**

---

## 先看数据

118k Stars、9.5k Forks，已上架 Claude Code 官方插件市场，支持 Claude Code、Cursor、Codex、OpenCode、Gemini CLI 全主流平台。这是目前 AI 开发工具里增长最快的开源项目之一，但它不是 SDD 工具。

---

## Superpowers 的本质

它的副标题是 **"An agentic skills framework & software development methodology"**，核心不是"规格驱动"，而是**"工作流强制执行"**。

它解决的问题是：

> AI 拿到任务就直接开始写代码，没有思考，没有计划，出了问题就循环乱转。

Superpowers 的方案是给 AI 装上**强制触发的工作流门禁**：

```
看到要构建的东西
    ↓ 自动触发 brainstorming
把想法梳理成设计文档，分块展示给你确认
    ↓ 确认后自动触发 writing-plans
生成明确到"文件路径+完整代码+验证步骤"的任务计划
    ↓ 自动触发 subagent-driven-development
每个任务派一个新 Subagent 执行，两阶段 Review（Spec 合规 → 代码质量）
    ↓ 自动触发 test-driven-development
RED-GREEN-REFACTOR，写测试前不许写代码
    ↓ 完成后触发 requesting-code-review
    ↓ 触发 finishing-a-development-branch
```

**每个 Skill 都是自动触发的，不是建议，是强制流程。** 这是它和普通 CLAUDE.md 的根本区别。

---

## 和 SDD 的关键差异

```
维度              SDD（Spec-Kit/BMAD/OpenSpec）    Superpowers
──────────────────────────────────────────────────────────────
第一公民           Spec 文档                         工作流过程
Spec 的生命周期    长期维护，版本控制，持续演进         会话级产物，用完即止
设计文档的角色     代码的唯一真相来源                  计划的起点，不是源头
核心创新           结构化规格管理                      强制工作流 + Subagent 架构
TDD               可选或推荐                          强制，写代码前必须先写测试
适合场景           需求复杂、多人协作、长期演进          单次任务、快速迭代、个人/小团队
```

最关键的一条：SDD 里 Spec 是**被长期维护**的制品，代码是它的输出。Superpowers 的 `brainstorming` 生成的设计文档是**会话级**的，任务完成后它不再被主动维护，不是项目的长期真相来源。

---

## Superpowers 真正的定位

它更接近 **"纪律化 Vibe Coding"** 而不是 SDD。它的哲学是：

> Vibe Coding 失控不是因为缺少规格文档，而是因为 AI 没有被强制遵守合理的工程流程。给它装上强制流程，Vibe Coding 就能变得可靠。

这和 SDD 的哲学 "代码是规格的输出" 是两条不同的路线。

---

## 但它对我们的 BladeX 工程化有价值

虽然不是 SDD 工具，但 Superpowers 有几个机制直接可以用：

**`brainstorming` Skill** 和我们之前讨论的"阶段0需求澄清"完全对应，可以替代手写的结构化 Prompt 模板。

**`writing-plans`** 生成的任务粒度（2-5分钟一个任务，精确到文件路径和验证步骤）比 Spec-Kit 的 `/tasks` 更细，对 BladeX 这类有明确代码规范的框架非常合适。

**`subagent-driven-development`** 的两阶段 Review（先验证是否符合计划，再验证代码质量）可以直接嵌入我们的 CI 门禁思路。

**最务实的组合**：用 Superpowers 管理**单个模块的开发流程**，用 OpenSpec 管理**跨模块的需求变更追踪**，两者不冲突，各管一层。