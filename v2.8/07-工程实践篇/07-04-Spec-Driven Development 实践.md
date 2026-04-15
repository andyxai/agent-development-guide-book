# 第 26 章：Spec-Driven Development 实践

**版本**: v1.0  
**作者**: 主编（小助手）  
**状态**: draft  
**最后更新**: 2026-04-13

---

【本章导读】
- **本章学习目标**：掌握 Spec-Driven Development（规范驱动开发）的核心理念、工具链和最佳实践
- **核心内容概述**：从传统的 Prompt Engineering 到 Spec-Driven Development 的演进，Spec 编写方法、主流工具对比、工程化工作流
- **为什么重要**：当 AI 编码从探索性实验走向生产系统，Spec 提供了结构化的"真相来源"，防止技术债务累积和意图偏离

---

## 26.1 Spec 驱动开发概述

**总**：Spec-Driven Development 是一种以正式规范为权威性真相来源的开发范式，规范直接指导 AI 生成可执行代码。

### 1. 什么是 Spec-Driven Development

**定义**：Spec-Driven Development（SDD，规范驱动开发）是一种软件工程方法论，其中**正式的、机器可读的规范（Specification）作为权威性真相来源（Source of Truth）**，直接指导并生成可执行代码。

**核心哲学**：
- **意图驱动（Intent-driven）**：规范定义"做什么"（What），而非"怎么做"（How）
- **规范即执行（Executable Specs）**：规范不再是废弃的脚手架，而是直接生成工作实现的 blueprint
- **多步精炼（Multi-step Refinement）**：而非一次性代码生成的 prompt
- **重度依赖 AI**：依赖先进 AI 模型对规范的解释能力

### 2. 与传统开发模式的对比

| 维度 | TDD（测试驱动） | BDD（行为驱动） | DDD（领域驱动） | SDD（规范驱动） |
|------|----------------|----------------|----------------|----------------|
| **起点** | 失败的测试用例 | 用户故事/场景 | 领域模型 | 正式规范文档 |
| **核心关注** | 实现正确性 | 利益相关者协作 | 领域边界与语言 | 规范作为真相来源 |
| **主要产物** | 单元测试套件 | 可执行场景规范 | 领域模型与聚合 | 规范+生成的代码+测试 |
| **适用场景** | 单元级实现细节 | 业务行为验证 | 复杂业务系统 | AI辅助开发、API、微服务 |
| **与AI关系** | 互补 | 互补 | 互补 | **原生适配AI编码** |

**关键差异**：
- **TDD**：先写测试→写代码→重构（关注实现正确性）
- **SDD**：先写规范→生成测试和文档→AI 生成代码→验证（关注合同清晰度）
- SDD 可以**包含 TDD 和 BDD**，规范可自动生成测试用例

### 3. 三种规范严格度级别

根据行业实践总结（参考 ThoughtWorks、Amazon Kiro、GitHub Spec Kit 等官方文档）：

| 级别 | 名称 | 定义 | 适用场景 |
|------|------|------|---------|
| **L1** | Spec-First（规范优先） | 先写规范，用于指导 AI 辅助开发工作流 | 中等复杂度功能 |
| **L2** | Spec-Anchored（规范锚定） | 规范作为参考锚点，与代码共同演进 | 快速迭代项目 |
| **L3** | Spec-as-Source（规范即源码） | 规范是唯一真相来源，代码是衍生品 | 企业级、合规要求高的项目 |

**总**：SDD 不是 TDD 的替代品，而是 AI 编码时代的工程化升级，特别适合需要长期维护和团队协作的项目。

---

## 26.2 Spec 与 Prompt 的关系

**总**：Spec 是结构化的 Prompt，但二者在粒度、持久性和适用场景上有本质区别。

### 1. Spec vs Prompt vs Requirements

| 维度 | Prompt | Spec | Requirements |
|------|--------|------|--------------|
| **形式** | 对话式、临时 | 结构化文档（Markdown） | 正式文档（PRD/SRS） |
| **粒度** | 单次任务 | 功能/特性级别 | 系统/项目级别 |
| **持久性** | Ephemeral（聊天记录） | 版本控制文件 | 正式文档管理系统 |
| **审查** | 低（聊天流中） | 高（独立文档） | 非常高（正式评审） |
| **适用** | 快速迭代、探索 | AI编码、中等复杂度 | 大型企业项目 |
| **AI友好度** | 中（依赖上下文） | 高（结构化、可引用） | 低（过于庞大） |
| **变更成本** | 低 | 中 | 高 |

### 2. 何时使用 Spec 而非 Prompt

| 场景 | 推荐方法 | 原因 |
|------|---------|------|
| 修复 bug | **Prompt-First** | 快速，范围明确 |
| 调整单个函数 | **Prompt-First** | 探索性，不需要承诺 |
| 设计新功能 | **Spec-First** | 需要对齐，非速度 |
| 设计 API/服务 | **Spec-First** | 其他人将依赖 |
| 重大重构 | **Spec-First** | 高错误成本 |
| 长期维护项目 | **Spec-First** | 将存在数年 |

**核心判断标准**：
- **Prompt Engineering**：任务小、个人、不确定 → 探索而非承诺
- **Spec-Driven Development**：任务大、协作、关键 → 需要对齐而非速度

### 3. Spec 的结构化特征

1. **可执行性**：AI 可直接从 spec 生成实现
2. **机器可读**：Markdown/XML 标签，结构清晰
3. **人类可审**：简洁、聚焦、可验证
4. **版本化**：与代码一起 git 管理
5. **可追溯**：task → commit → test 双向链接

**关系演进**：
```
Requirements（产品需求） 
    ↓ 分解
Spec（技术规格，AI可执行）
    ↓ 驱动
Code（实现）
    ↕ 验证
Tests（测试用例）
```

**总**：Spec 是 Prompt 的结构化升级，当任务复杂度超过单轮对话能处理的范围时，就应该切换到 Spec 模式。

---

## 26.3 Spec 编写最佳实践

**总**：高质量的 Spec 是 SDD 成功的关键，需要平衡完整性和简洁性。

### 1. 从高层愿景开始，让 AI 补充细节

**初始提示模板**：
```
你是 AI 软件工程师。为[项目 X]起草详细规格，
覆盖目标、功能、约束和逐步计划。
```

**工作流**：
1. 先写简短目标陈述（1-2 段）
2. AI 生成完整 spec 草稿
3. 使用 Plan Mode（只读）refine 后再执行

### 2. Spec 必须覆盖的 6 大区域

GitHub 分析 2500+ agent 配置文件，最有效 spec 覆盖以下区域：

| 区域 | 内容 | 示例 |
|------|------|------|
| **Commands** | 可执行命令及参数 | `npm test`, `pytest -v` |
| **Testing** | 测试框架/位置/覆盖率 | `tests/`目录，Jest |
| **Project Structure** | 代码/测试/文档位置 | `src/`, `tests/`, `docs/` |
| **Code Style** | 真实代码示例 > 文字描述 | 命名约定、格式化 |
| **Git Workflow** | 分支/提交/PR规范 | `feat/`, `fix/`前缀 |
| **Boundaries** | 绝不触碰的区域 | 密钥、vendor、生产配置 |

### 3. 有意义地分解（Meaningful Decomposition）

使用 **INVEST 框架**验证 spec 质量：
- **Independent**：功能可独立交付
- **Negotiable**：细节可协商
- **Valuable**：对用户有价值
- **Estimable**：可估算工作量
- **Small**：足够小（1-3 天完成）
- **Testable**：可测试验证

使用 **MoSCoW 优先级**：
- **Must have**：必须有（核心功能）
- **Should have**：应该有（重要但非关键）
- **Could have**：可以有（锦上添花）
- **Won't have**：本次不做（明确排除）

### 4. 最小化 Spec（Minimal Specifications）

**原则**：
- 避免长链"and"语句膨胀复杂度
- 捕获当前功能所需，不提前指定未来需求
- **Human Reviewability 测试**：如果发现自己在略读 spec 变更，说明功能太大

### 5. Spec 模板示例

```markdown
# Project Spec: 任务管理 API

## Objective
- 构建 RESTful API 支持团队任务的创建、分配、追踪

## Tech Stack
- FastAPI, PostgreSQL, SQLAlchemy
- Pytest 用于测试，Alembic 用于迁移

## Commands
- Build: `make build`
- Test: `make test`（提交前必须通过）
- Lint: `make lint`

## Boundaries
- ✅ Always: 提交前运行测试和 lint
- ⚠️ Ask first: 数据库 schema 变更
- 🚫 Never: 提交密钥、修改 vendor 目录
```

**总**：高质量 spec 的关键是"简洁地完整"——捕获必要细节，避免过度设计。

---

## 26.4 主流工具对比

**总**：2025-2026 年 SDD 工具爆发，选择取决于项目需求和团队规模。

### 1. 工具全景对比

| 工具 | 类型 | 核心特性 | 适用场景 | 学习成本 |
|------|------|---------|---------|---------|
| **GitHub Spec Kit** | 开源工具包 | 4阶段标准流程，Specify CLI，跨Agent支持 | 参考实现、团队协作 | 中 |
| **Amazon Kiro** | AI-native IDE | 3阶段工作流，EARS notation，深度AWS集成 | 企业级、AWS项目 | 中 |
| **Claude Code** | Agentic CLI | Plan Mode，Subagents系统，Task持久化 | CI/CD集成、自动化 | 低 |
| **OpenSpec** | 轻量框架 | fluid not rigid，适合brownfield迭代 | 快速原型、小团队 | 低 |
| **Cursor** | AI编辑器 | Rules文件，内置聊天，Ask/Agent模式 | 快速迭代、个人开发 | 低 |
| **Intent** | 企业平台 | Living Specs，多Agent编排，双向同步 | 复杂多服务架构 | 高 |

### 2. GitHub Spec Kit（开源标准）

**核心组件**：
- **Specify CLI**：Python 工具，一键初始化 SDD 项目
  ```bash
  uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
  ```
- **模板系统**：`.specify/templates/` 包含 spec、plan、tasks 模板
- **Constitution 文档**：项目不可协商的原则（测试标准、CLI-first 等）

**Slash Commands**：
| 命令 | 功能 |
|------|------|
| `/speckit.constitution` | 创建项目治理原则 |
| `/speckit.specify` | 生成 PRD（what & why，不含技术决策） |
| `/speckit.plan` | 技术实现计划（how，框架/库/数据库） |
| `/speckit.tasks` | 可执行任务列表 |
| `/speckit.implement` | 执行所有任务 |

**跨 agent 兼容**：支持 GitHub Copilot、Claude Code、Gemini CLI、Codex CLI 等

### 3. Amazon Kiro（企业级 IDE）

**核心特性**：
- **Specs 系统**：内置结构化规范，将复杂功能分解为详细实现计划
- **EARS Notation**：Easy Approach to Requirements Syntax，标准化需求语法
- **追踪功能**：spec 与实现的双向追溯
- **SDD 工作流**：规范优先，代码后行

**设计理念**：不同于 Cursor/Copilot 注重速度，Kiro 强制结构化开发。

### 4. Claude Code（Agentic CLI）

**Spec 工作流实践**（4 阶段）：
1. **Research**：并行子 agent 研究（技术选型、架构对比）
2. **Spec Creation**：生成完整技术规格文档
3. **Spec Refinement**：通过 `AskUserQuestion` 工具进行访谈式澄清
4. **Implementation**：每个 task 分配给子 agent，保持上下文清晰

**架构优势**：
- 主 agent 负责编排，子 agent 获得新鲜上下文窗口
- 任务系统解决"Agent Amnesia"和"Context Pollution"问题
- 支持 Ralph 架构模式（**社区实践**，非官方功能）：
  ```bash
  # 无状态循环模式：每次从 PROMPT.md 读取任务，保持上下文清洁
  while :; do cat PROMPT.md | claude-code ; done
  ```
  **⚠️ 警告**：此为社区爱好者探索的用法，非 Anthropic 官方支持。生产环境需谨慎使用，建议参考官方文档的最佳实践。

**总**：工具选择次要，结构化思维优于工具选择。个人项目用 OpenSpec/Cursor，团队协作用 Spec Kit/Kiro，复杂架构用 Intent。

---

## 26.5 SDD 工作流详解

**总**：标准 SDD 工作流包含 4 个阶段，每个阶段都有明确的产出和验证点。

### 1. 标准 4 阶段流程

```
Specify（规范） → Plan（计划） → Tasks（任务分解） → Implement（实现）
```

| 阶段 | 输入 | 输出 | 验证方式 |
|------|------|------|---------|
| **Specify** | 产品需求 | spec.md（what & why） | 人类审查、利益相关者确认 |
| **Plan** | spec.md | plan.md（how，技术决策） | 架构审查、可行性验证 |
| **Tasks** | plan.md | tasks.md（可执行任务列表） | INVEST 框架验证 |
| **Implement** | tasks.md | 代码+测试+文档 | 自动化测试、代码审查 |

### 2. Spec 编写实战

**示例：用户认证系统**

```markdown
# Spec: 用户认证系统

## Objective
- 实现 JWT 认证，支持注册、登录、token 刷新

## Requirements
- 用户 MUST 能通过邮箱+密码注册
- 系统 MUST 返回 JWT access token（有效期 1 小时）
- 系统 MUST 支持 refresh token（有效期 7 天）
- 密码 MUST 使用 bcrypt 哈希存储

## Design
- 使用 FastAPI 的 OAuth2PasswordBearer
- 数据库表：users(id, email, password_hash, created_at)
- API 端点：POST /auth/register, POST /auth/login, POST /auth/refresh

## Testing
- 单元测试覆盖核心逻辑（>80%）
- 集成测试覆盖 API 端点
- 测试目录：tests/auth/

## Boundaries
- 🚫 Never: 明文存储密码
- ⚠️ Ask first: 修改 token 有效期
```

### 3. 任务分解示例

```markdown
# Tasks: 用户认证系统

## Task 1: 数据库模型
- 创建 users 表模型
- 添加 password_hash 字段
- 编写模型测试
- **预估**: 2 小时

## Task 2: 注册端点
- 实现 POST /auth/register
- 邮箱唯一性验证
- 密码哈希存储
- 编写端点测试
- **预估**: 4 小时

## Task 3: 登录端点
- 实现 POST /auth/login
- JWT token 生成
- 错误处理（密码错误、用户不存在）
- 编写端点测试
- **预估**: 4 小时

## Task 4: Token 刷新
- 实现 POST /auth/refresh
- refresh token 验证
- 新 token 生成
- 编写端点测试
- **预估**: 3 小时
```

### 4. 人在回路（Human-in-the-Loop）

**关键审查点**：
1. **Spec 审查**：AI 生成 spec 后，人类必须审查并确认意图
2. **Plan 审查**：技术决策是否符合项目架构
3. **边界确认**：明确哪些区域 AI 不能触碰
4. **最终验收**：代码实现是否符合 spec

**审查清单**：
- [ ] spec 是否捕获了真实需求？
- [ ] spec 是否足够简洁（Human Reviewability 测试）？
- [ ] 任务分解是否符合 INVEST 框架？
- [ ] 是否有明确的验收标准？

**总**：SDD 不是全自动开发，人类的角色从"写代码"转变为"确保 spec 反映真实设计意图"。

---

## 26.6 常见陷阱与反模式

**总**：SDD 的失败通常不是因为工具不好，而是因为团队没有遵循最佳实践。

### 1. 规范剧场（Specification Theater）

**表现**：编写详细的 spec 但无人阅读或验证

**避免**：
- spec 必须是团队积极使用的活文档
- 每次代码变更必须追溯到 spec 变更
- 定期审查 spec 与实现的对齐度

### 2. 过早全面性（Premature Comprehensiveness）

**表现**：试图一次性指定所有内容，而非迭代精炼

**避免**：
- 从最小 spec 开始
- 随理解加深而演进
- 避免过早指定未来需求或不立即相关的边缘情况

### 3. Spec-实现偏离（Spec-Implementation Drift）

**表现**：允许 spec 与实现分道扬镳

**避免**：
- 自动化检查确保 spec 与代码对齐
- 验证不是一次性 gate，而是开发全过程的持续实践
- 尽早捕获偏离，修复成本最低

### 4. AI 生成 Spec 膨胀（AI-Generated Specification Bloat）

**表现**：接受冗长的 AI 生成 spec 而不进行人类编辑

**避免**：
- 简洁性需要有意策划
- 人类判断决定 spec 是否捕获正确意图
- 删除冗余和过度设计的部分

### 5. 忽略跨功能效应（Ignoring Cross-Feature Effects）

**表现**：孤立分析功能而无系统思维

**避免**：
- 功能以非线性方式交互
- 检测跨功能冲突、反馈循环和级联效应
- 应用系统思维进行跨功能分析

### 6. 工具过度依赖（Tool Over-Reliance）

**表现**：相信正确的工具能解决分解问题

**避免**：
- 工具支持良好实践，但不能替代结构化思维
- 无工具能弥补糟糕的分解
- 先掌握方法论，再选择工具

**总**：SDD 的核心是思维方式的转变，工具只是辅助。避免"spec 剧场"，确保 spec 真正驱动开发。

---

## 26.7 简单举例

### 案例设计
- **案例名称**：从 Vibe Coding 到 Spec-Driven 的转变
- **涉及知识点**：Spec vs Prompt、SDD 工作流、Human-in-the-Loop
- **案例内容要点**：

**场景描述**：
某团队用 Cursor 快速开发了一个内部工具（Vibe Coding），2 周完成原型。但随着功能增加，代码开始失控：测试缺失、文档过时、新成员无法理解架构。

**技术应用**：
1. 团队引入 GitHub Spec Kit，为下一个功能编写 spec
2. Spec 包含：Objective、Requirements、Design、Testing、Boundaries
3. AI 根据 spec 生成代码和测试，人类审查 spec 变更
4. 每个功能独立 spec，可追溯

**效果说明**：
- 代码质量提升：测试覆盖率从 20% 提升到 85%
- 团队协作改善：新成员通过 spec 理解系统
- 技术债务减少：spec 与代码持续对齐，防止偏离
- 开发速度：初期慢 30%，但长期维护成本降低 60%

**教训**：Vibe Coding 适合探索，Spec-Driven 适合生产。团队需要"双语能力"，根据场景切换模式。

---

**知识来源**:
- [GitHub Spec Kit 官方仓库](https://github.com/github/spec-kit)（Star 数持续变化，请以 GitHub 实时数据为准）
- [ThoughtWorks - Spec-driven development: Unpacking one of 2025's key new AI-assisted engineering practices](https://www.thoughtworks.com/en-cn/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices)
- [Addy Osmani - How to write a good spec for AI agents](https://addyosmani.com/blog/good-spec/)
- [Amazon Kiro Docs - Specs](https://kiro.dev/docs/specs/)
- [Intent-Driven.dev - Best Practices for Spec-Driven Development](https://intent-driven.dev/knowledge/best-practices/)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)

---

**修改记录**:
- v1.0 (2026-04-13): 初始版本，覆盖 SDD 核心概念、工具对比、最佳实践
