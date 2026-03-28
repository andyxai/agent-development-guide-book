# 第 26 章：AI Coding 最佳实践

**版本**: v3.0（AI Coding 通用知识整合版）  
**最后更新**: 2026-03-27  
**状态**: ✅ 完成

---

## 【本章导读】

**学习目标**:
- 理解 AI Coding 的三种模式（快速/计划/规格）及其适用场景
- 掌握 Spec-Driven Development 的三阶段流程
- 能够设计符合 AI Coding 规范的项目结构
- 理解 Harness Engineering 的核心思想和实践方法

**核心知识点**:
- 模式选择决策框架（简单/中等/复杂任务）
- Spec 模式三阶段（Requirements → Design → Implementation）
- EARS 格式需求文档
- 项目结构规范（docs/, scripts/, .ai/, AGENTS.md）
- 知识可见性原则
- Hooks 配置与自动化
- 自动修复机制
- Harness Engineering 实践

**涉及面试题**:
- 如何根据任务复杂度选择合适的 AI 编程模式？
- Spec-Driven Development 的核心流程是什么？
- 如何设计 AI Coding 项目结构以确保知识可见性？
- Harness Engineering 的三组件是什么？

---

## 26.1 模式选择决策框架

### 26.1.1 三种 AI 编程模式

AI Coding 工具提供三种协作模式，根据任务复杂度选择：

| 模式 | 别名 | 适用场景 | 文档需求 |
|------|------|---------|---------|
| **快速模式** | Vibe Mode | 小修小补 (<30 分钟) | ❌ 无需文档 |
| **计划模式** | Plan Mode | 中等任务 (1-4 小时) | ⚠️ 简易计划 |
| **规格模式** | Spec Mode | 复杂任务 (>4 小时) | ✅ 完整 Spec |

> **工具实现示例**:
> - **Qoder Quest Mode**: Vibe/Plan/Spec 三种场景
> - **Cursor Composer**: 快速模式（直接对话）/ 规格模式（Spec 文档）
> - **GitHub Copilot Workspace**: Spec-driven 任务

### 26.1.2 模式选择决策矩阵

| 维度 | 快速模式 | 计划模式 | 规格模式 |
|------|---------|---------|---------|
| **时间估算** | < 30 分钟 | 1-4 小时 | > 4 小时 |
| **文件数量** | 1-2 个 | 3-10 个 | 10+ 个 |
| **风险级别** | 低 | 中 | 高 |
| **文档需求** | 不需要 | 简单文档 | 完整文档 |
| **协作需求** | 单人 | 小团队 | 多团队 |

### 26.1.3 工作流程对比

**快速模式（Vibe）**:
```
直接描述需求 → Agent 执行 → 查看结果 → 接受/拒绝
```

**示例**:
```
✅ "把这个函数改成异步"
✅ "添加一个日志输出"
✅ "修复这个拼写错误"
```

**计划模式（Plan）**:
```
需求澄清 → 生成计划 → 用户确认 → 执行 → 审查结果
```

**示例**:
```
✅ "重构用户模块，拆分为服务和控制器"
✅ "添加用户权限管理功能"
✅ "优化数据库查询性能"
```

**规格模式（Spec）**:
```
Requirements（需求） → Design（设计） → Implementation（执行）
```

**示例**:
```
✅ "实现完整的用户登录系统"
✅ "开发漫剧剧本生成功能"
✅ "重构整个数据访问层"
```

---

## 26.2 Spec-Driven Development（规格驱动开发）

### 26.2.1 三阶段流程

```
┌─────────────────────────────────────────────────────────────────┐
│                Spec 模式三阶段流程                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  阶段 1: Requirements → 阶段 2: Design → 阶段 3: Implementation  │
│       ↓                    ↓                    ↓               │
│  需求澄清 (EARS)       技术方案设计        代码执行            │
│  验收条件定义          任务分解            自动验证            │
│  多项选择题确认        接口定义            自动修复 (最多 3 次)   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 26.2.2 阶段 1：Requirements（需求）

**目标**: 明确需求，消除歧义

**活动**:
- 需求澄清（多项选择题）
- 用户意图识别
- 验收条件定义（EARS 格式）
- 边界情况识别

**产出物模板**:
```markdown
# 需求文档：用户登录功能

## 背景
用户需要通过邮箱和密码登录系统

## 验收条件（EARS 格式）

### 功能需求
- WHEN 用户输入正确的邮箱和密码 THEN 系统应该成功登录并返回 JWT token
- WHEN 用户输入错误的密码 THEN 系统应该返回"密码错误"提示
- WHEN 用户输入不存在的邮箱 THEN 系统应该返回"用户不存在"提示

### 边界情况
- WHEN 用户连续输错密码 5 次 THEN 系统应该锁定账户 15 分钟
- WHEN 用户 session 过期 THEN 系统应该自动跳转到登录页

### 非功能需求
- 登录接口响应时间 < 500ms
- 密码必须使用 bcrypt 加密
- JWT token 有效期 24 小时
```

### 26.2.3 EARS 格式详解

**EARS** = **E**asy **A**pplication of **R**equirement **S**pecification

**核心结构**:
```
WHEN <触发条件> THEN <系统响应>
```

**为什么用 EARS？**

| 优势 | 说明 |
|------|------|
| **清晰** | 条件和结果明确分离 |
| **可测试** | 每个需求都是可验证的 |
| **无歧义** | 避免模糊表述 |
| **Agent 友好** | 结构化格式便于 AI 理解 |

**好 vs 坏的 EARS**:

**坏的需求**:
```
❌ "系统应该处理登录"
❌ "密码要加密"
❌ "性能要好"
```

**好的 EARS 需求**:
```
✅ WHEN 用户输入正确的邮箱和密码 THEN 系统应该成功登录并返回 JWT token
✅ WHEN 用户连续输错密码 5 次 THEN 系统应该锁定账户 15 分钟
✅ 登录接口响应时间 < 500ms
✅ 密码必须使用 bcrypt 加密
```

### 26.2.4 阶段 2：Design（设计）

**目标**: 设计技术方案，明确实现路径

**活动**:
- 技术选型
- 架构设计
- 接口定义
- 任务分解

**产出物模板**:
```markdown
# 设计文档：用户登录功能

## 技术方案
- 技术栈：Node.js + Express + MongoDB
- 架构：MVC 模式

## 接口定义
- POST /api/login - 用户登录
- POST /api/logout - 用户登出

## 任务分解
- [ ] 创建 User 模型
- [ ] 实现登录接口
- [ ] 实现 JWT token 生成
- [ ] 添加单元测试

## 验收标准
- [ ] 所有测试通过
- [ ] 代码规范检查通过
- [ ] 性能测试通过
```

### 26.2.5 阶段 3：Implementation（执行）

**目标**: 按 Spec 执行，交付结果

**活动**:
- 代码实现
- 自动验证
- 自动修复（最多 3 次）
- 结果审查

**产出物**:
- 代码变更
- 测试报告
- 验证结果

**执行完成后的操作**:
- **Accept**（本地模式）: 应用所有变更到工作区
- **Reject**（本地模式）: 丢弃所有变更
- **Apply**（并行模式）: 合并到主分支
- **Create PR**（远程模式）: 创建 Pull Request

---

## 26.3 项目结构规范

### 26.3.1 标准项目结构

```
project/
├── docs/
│   ├── architecture.md      # 架构决策
│   ├── coding-standards.md  # 编码规范
│   ├── common-pitfalls.md   # 常见坑点
│   └── specs/
│       ├── 01-requirements.md
│       └── 02-design.md
├── scripts/
│   ├── lint.sh              # Lint 脚本
│   ├── test.sh              # 测试脚本
│   └── verify.sh            # 验证脚本
├── .ai/
│   ├── rules/
│   │   └── coding-rules.md  # 编码规则
│   └── hooks.json           # Hooks 配置
└── AGENTS.md                # 导航地图
```

### 26.3.2 目录说明

| 目录/文件 | 用途 | 详细内容 |
|----------|------|---------|
| **docs/** | 文档中心 | 架构、规范、坑点、Spec |
| **docs/architecture.md** | 架构决策 | 技术选型、系统设计、关键决策 |
| **docs/coding-standards.md** | 编码规范 | 命名规范、代码风格、最佳实践 |
| **docs/common-pitfalls.md** | 常见坑点 | 历史问题、解决方案、避免方法 |
| **docs/specs/** | Spec 文档 | 需求文档、设计文档 |
| **scripts/** | 自动化脚本 | Lint/测试/验证 |
| **scripts/lint.sh** | 代码规范检查 | ESLint/Prettier/其他检查 |
| **scripts/test.sh** | 测试脚本 | 单元测试、集成测试 |
| **scripts/verify.sh** | 验证脚本 | 端到端验证、部署验证 |
| **.ai/rules/** | AI 规则 | AI 编码规则、约束 |
| **.ai/hooks.json** | Hooks 配置 | 自动化触发配置 |
| **AGENTS.md** | 导航地图 | 项目导航、文档索引 |

> **注意**: `.ai/` 目录是通用命名，不同工具可能使用不同名称：
> - Qoder: `.qoder/`
> - Cursor: `.cursor/`
> - GitHub Copilot: `.github/copilot/`
> - 通用推荐：`.ai/` 或 `.agent/`

---

## 26.4 AGENTS.md 编写规范

### 26.4.1 核心要点

1. **控制在 100 行左右** - 保持简洁，避免冗长
2. **告诉 Agent"去哪里找什么"** - 导航式结构，不是内容本身
3. **详细内容放在链接文档里** - 不要全部塞进 AGENTS.md

### 26.4.2 AGENTS.md 模板

```markdown
# AGENTS.md - Agent 导航指南

## 快速导航
- **项目结构**: `src/` (代码), `docs/` (文档), `scripts/` (脚本)
- **构建命令**: `npm run build`, `npm test`
- **关键文档**: 见下方文档索引

## 文档索引
| 文档 | 位置 | 用途 |
|------|------|------|
| 架构设计 | [docs/architecture.md](docs/architecture.md) | 系统架构、技术选型 |
| 编码规范 | [docs/coding-standards.md](docs/coding-standards.md) | 命名规范、代码风格 |
| 常见坑点 | [docs/common-pitfalls.md](docs/common-pitfalls.md) | 历史问题、解决方案 |
| Spec 文档 | [docs/specs/](docs/specs/) | 需求文档、设计文档 |

## 验证脚本
| 脚本 | 命令 | 用途 |
|------|------|------|
| 代码规范 | `./scripts/lint.sh` | ESLint + Prettier 检查 |
| 单元测试 | `./scripts/test.sh` | Jest 单元测试 |
| 端到端验证 | `./scripts/verify.sh` | 完整流程验证 |

## Hooks 配置
- **pre-commit**: 代码提交前自动运行 lint
- **post-edit**: 代码变更后自动验证

## 自动修复机制
当验证失败时：
1. 分析错误日志
2. 定位问题代码
3. 修复并重新验证
4. 最多重试 3 次
5. 反复失败则请求人工介入

---
**详细文档**: 点击上方链接查看完整内容
```

---

## 26.5 知识可见性原则

### 26.5.1 核心要点

1. **Agent 看不到的东西对它来说就不存在**
   - Agent 只能访问仓库内的文件
   - 外部知识对 Agent 是"隐形"的
   - 所有知识必须写入仓库

2. **技术决策、架构判断都要写进仓库**
   - 不能只存在于人类头脑中
   - 不能只在聊天历史记录里
   - 必须形成文档（docs/architecture.md）

3. **不依赖 Notion、Confluence 等外部平台**
   - 外部平台 Agent 无法访问
   - 知识孤岛问题
   - 所有知识应在 Git 仓库内

### 26.5.2 实践建议

**应该做**:
- ✅ 所有技术决策写入 `docs/architecture.md`
- ✅ 所有 Spec 文档存入 `docs/specs/`
- ✅ 所有经验教训写入 `docs/common-pitfalls.md`
- ✅ AGENTS.md 导航到所有关键文档

**不应该做**:
- ❌ 技术决策只在 Slack 讨论
- ❌ Spec 文档放在 Notion
- ❌ 架构判断只在人类头脑中
- ❌ 依赖外部 Wiki 系统

---

## 26.6 自动化与 Hooks

### 26.6.1 Hooks 配置文件格式

```json
{
  "hooks": {
    "pre-commit": {
      "command": "bash scripts/lint.sh",
      "description": "代码提交前自动运行 lint"
    },
    "post-edit": {
      "command": "bash scripts/verify.sh",
      "description": "代码变更后自动验证"
    },
    "pre-apply": {
      "command": "bash scripts/test.sh",
      "description": "Spec 执行前运行测试"
    },
    "post-task": {
      "command": "bash scripts/notify.sh",
      "description": "任务完成后通知"
    }
  }
}
```

### 26.6.2 Hooks 类型

| Hook | 触发时机 | 用途 | 示例命令 |
|------|---------|------|---------|
| **pre-commit** | 代码提交前 | 确保提交质量 | `bash scripts/lint.sh` |
| **post-edit** | 代码变更后 | 自动验证变更 | `bash scripts/verify.sh` |
| **pre-apply** | Spec 执行前 | 验证 Spec 完整性 | `bash scripts/validate-spec.sh` |
| **post-task** | 任务完成后 | 清理和通知 | `bash scripts/notify.sh` |

### 26.6.3 与项目结构的关系

```
project/
├── .ai/
│   └── hooks.json         ← Hooks 配置文件
├── scripts/
│   ├── lint.sh            ← pre-commit 调用
│   ├── test.sh
│   └── verify.sh          ← post-edit 调用
└── AGENTS.md
```

---

## 26.7 自动修复机制

### 26.7.1 自动修复流程

```
验证失败
    ↓
分析错误日志 → 定位问题代码 → 修复并重新验证
    │                              │
    │                              ↓
    │                         验证通过？
    │                             │
    │              ┌──────────────┼──────────────┐
    │              │ Yes          │              │ No
    │              ↓              │              ↓
    │         修复成功            │         重试次数<3?
    │                             │              │
    │                             │    ┌─────────┴─────────┐
    │                             │    │ Yes               │ No
    │                             │    ↓                   ↓
    │                             │  返回修复步骤      请求人工介入
    │                             │
    └─────────────────────────────┘
```

### 26.7.2 AGENTS.md 自愈指导

```markdown
## 自动修复机制

当验证失败时，Agent 应遵循以下流程：

### 修复流程
1. **分析错误日志**: 查看 `scripts/verify.sh` 输出
2. **定位问题代码**: 根据错误信息定位文件
3. **修复并重新验证**: 修复后运行 `bash scripts/verify.sh`
4. **最多重试 3 次**: 避免无限循环
5. **请求人工介入**: 3 次失败后标记 `ACTION_REQUIRED`

### 常见错误处理
| 错误类型 | 处理方式 |
|---------|---------|
| Lint 错误 | 自动运行 `bash scripts/lint.sh --fix` |
| 测试失败 | 分析失败用例，修复后重测 |
| Spec 不符 | 重新对齐 Spec 要求 |

### 人工介入条件
- 连续 3 次修复失败
- 需要架构级修改
- 涉及外部依赖问题
```

---

## 26.8 Harness Engineering 实践

### 26.8.1 核心定义

**Harness Engineering** 是 OpenAI 提出的一套 AI Coding 方法论。

### 26.8.2 核心思想

- **人类角色转变**: 从"写代码"变成"设计环境"
- **人类职责**:
  - 设计环境（项目结构、规范、约束）
  - 明确意图（Spec、验收标准）
  - 构建反馈回路（Lint、测试、验证）
- **Agent 职责**: 在 Harness 体系中可靠地工作

> **核心理念**:
> "人类不再写代码，而是设计环境、明确意图、构建反馈回路，
> 让 Agent 在这套体系中可靠地工作。"

### 26.8.3 Harness 三组件

| 组件 | 实现方式 | 示例 |
|------|---------|------|
| **设计环境** | 项目结构 + 规范 | docs/, scripts/, .ai/ |
| **明确意图** | Spec + EARS | 需求文档、设计文档 |
| **反馈回路** | Hooks + 自动验证 | pre-commit, post-edit |

### 26.8.4 与 Agent Engineering 对比

| 维度 | Harness Engineering | Agent Engineering |
|------|-------------------|-----------------|
| **提出者** | OpenAI | Anthropic |
| **核心思想** | 设计环境让 Agent 可靠工作 | 构建高效、可靠的 Agent 系统 |
| **人类角色** | 环境设计者 | Agent 构建者 |
| **关注点** | 环境、意图、反馈回路 | Agent 架构、测试、评估 |
| **关系** | 互补，可结合使用 | 互补，可结合使用 |

---

## 26.9 完整实战案例：用户登录功能

### 26.9.1 案例背景

**需求**: 为漫剧平台实现用户登录功能

**任务复杂度评估**:
- 时间估算：> 4 小时（复杂任务）
- 文件数量：10+ 个（模型、控制器、路由、测试）
- 风险级别：高（涉及用户认证安全）
- 协作需求：多团队（前端、后端、测试）

**模式选择**: **规格模式（Spec Mode）**

### 26.9.2 阶段 1：Requirements（需求）

**步骤 1: 创建需求文档**

创建文件：`docs/specs/01-user-login-requirements.md`

```markdown
# 需求文档：用户登录功能

## 背景
漫剧平台用户需要通过邮箱和密码登录系统，访问个人收藏和创作内容。

## 验收条件（EARS 格式）

### 功能需求
- WHEN 用户输入正确的邮箱和密码 THEN 系统应该成功登录并返回 JWT token
- WHEN 用户输入错误的密码 THEN 系统应该返回"密码错误"提示
- WHEN 用户输入不存在的邮箱 THEN 系统应该返回"用户不存在"提示
- WHEN 用户成功登录 THEN 系统应该记录登录时间和 IP 地址

### 边界情况
- WHEN 用户连续输错密码 5 次 THEN 系统应该锁定账户 15 分钟
- WHEN 用户账户被锁定 THEN 系统应该返回"账户已锁定，请 15 分钟后再试"提示
- WHEN 用户 session 过期 THEN 系统应该自动跳转到登录页
- WHEN 用户忘记密码 THEN 系统应该提供"忘记密码"链接

### 非功能需求
- 登录接口响应时间 < 500ms（P95）
- 密码必须使用 bcrypt 加密（cost factor = 12）
- JWT token 有效期 24 小时
- 支持并发登录数：1000 QPS
- 安全性：防止暴力破解、SQL 注入、XSS 攻击
```

**步骤 2: Agent 需求澄清**

Agent 可能会提出澄清问题（多项选择题）：

```
Q1: 支持哪些登录方式？
  A) 仅邮箱 + 密码 ✓ (推荐)
  B) 邮箱 + 密码 + 手机号
  C) 第三方登录（Google/GitHub）

Q2: 需要记住登录状态吗？
  A) 不需要
  B) 需要，7 天内免登录 ✓ (推荐)
  C) 需要，30 天内免登录

Q3: 密码复杂度要求？
  A) 最低 6 位
  B) 最低 8 位，包含字母和数字 ✓ (推荐)
  C) 最低 10 位，包含字母、数字和特殊字符
```

### 26.9.3 阶段 2：Design（设计）

**步骤 1: 创建设计文档**

创建文件：`docs/specs/02-user-login-design.md`

```markdown
# 设计文档：用户登录功能

## 技术方案
- 技术栈：Node.js + Express + MongoDB
- 架构：MVC 模式
- 认证：JWT (JSON Web Token)
- 加密：bcrypt (cost factor = 12)

## 接口定义

### POST /api/auth/login
**请求**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**成功响应** (200):
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "123",
      "email": "user@example.com",
      "name": "张三"
    }
  }
}
```

**失败响应** (401):
```json
{
  "success": false,
  "error": {
    "code": "INVALID_PASSWORD",
    "message": "密码错误"
  }
}
```

## 数据库设计

### User 集合
```javascript
{
  _id: ObjectId,
  email: String (unique, indexed),
  password: String (bcrypt hash),
  name: String,
  loginAttempts: Number,
  lockUntil: Date,
  lastLoginIP: String,
  createdAt: Date,
  updatedAt: Date
}
```

## 任务分解
- [ ] 创建 User 模型（含密码加密）
- [ ] 实现登录接口（含错误处理）
- [ ] 实现 JWT token 生成
- [ ] 实现账户锁定机制
- [ ] 添加登录日志记录
- [ ] 编写单元测试
- [ ] 编写集成测试
- [ ] 性能测试（1000 QPS）

## 验收标准
- [ ] 所有单元测试通过（覆盖率 > 90%）
- [ ] 所有集成测试通过
- [ ] 代码规范检查通过（ESLint）
- [ ] 性能测试通过（P95 < 500ms）
- [ ] 安全测试通过（OWASP Top 10）
```

**步骤 2: 审查设计文档**

通过对话调整设计：

```
用户：JWT token 有效期改为 7 天，支持记住登录状态
Agent: 好的，我会更新设计文档，添加 refresh token 机制...

用户：密码复杂度要求提高，最低 10 位，包含字母、数字和特殊字符
Agent: 好的，我会更新密码验证逻辑...
```

**步骤 3: 确认并执行**

点击 "Run Spec" 开始执行。

### 26.9.4 阶段 3：Implementation（执行）

**步骤 1: 监控执行进度**

Agent 会创建 To-do List 并实时更新：

```
执行进度:
✅ 创建 User 模型（含密码加密）
✅ 实现登录接口（含错误处理）
✅ 实现 JWT token 生成
✅ 实现账户锁定机制
🔄 添加登录日志记录 (进行中)
⏳ 编写单元测试
⏳ 编写集成测试
⏳ 性能测试（1000 QPS）
```

**步骤 2: 查看代码变更**

在 "Changed Files" Tab 中查看生成的代码：

```
生成的文件:
- src/models/User.js (用户模型)
- src/controllers/authController.js (认证控制器)
- src/routes/auth.js (认证路由)
- src/middleware/auth.js (认证中间件)
- src/utils/jwt.js (JWT 工具)
- tests/auth.test.js (单元测试)
- tests/auth.integration.test.js (集成测试)
```

**步骤 3: 中途添加需求**

```
用户：添加登录日志记录功能，记录每次登录的时间和 IP
Agent: 好的，我会在 User 模型中添加 lastLoginIP 和 lastLoginAt 字段，
      并在登录接口中添加日志记录逻辑...
```

### 26.9.5 验证与审查

**步骤 1: 自动验证**

Agent 会自动运行验证脚本：

```bash
# 运行测试
$ npm test

# 输出:
PASS  tests/auth.test.js
  登录功能
    ✓ 应该成功登录 (50ms)
    ✓ 应该返回密码错误 (30ms)
    ✓ 应该返回用户不存在 (25ms)
    ✓ 应该锁定账户 (100ms)

PASS  tests/auth.integration.test.js
  登录集成测试
    ✓ 完整登录流程 (200ms)
    ✓ JWT token 验证 (150ms)

Test Suites: 2 passed, 2 total
Tests:       6 passed, 6 total
Snapshots:   0 total
Time:        2.5s
```

**步骤 2: 代码审查**

检查生成的代码质量：

```javascript
// src/controllers/authController.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // 1. 查找用户
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({
        success: false,
        error: { code: 'USER_NOT_FOUND', message: '用户不存在' }
      });
    }
    
    // 2. 检查账户是否被锁定
    if (user.lockUntil && user.lockUntil > new Date()) {
      return res.status(423).json({
        success: false,
        error: { code: 'ACCOUNT_LOCKED', message: '账户已锁定，请 15 分钟后再试' }
      });
    }
    
    // 3. 验证密码
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      // 增加登录失败次数
      user.loginAttempts += 1;
      if (user.loginAttempts >= 5) {
        user.lockUntil = new Date(Date.now() + 15 * 60 * 1000); // 锁定 15 分钟
      }
      await user.save();
      
      return res.status(401).json({
        success: false,
        error: { code: 'INVALID_PASSWORD', message: '密码错误' }
      });
    }
    
    // 4. 生成 JWT token
    const token = jwt.sign(
      { userId: user._id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );
    
    // 5. 重置登录失败次数，记录登录信息
    user.loginAttempts = 0;
    user.lockUntil = undefined;
    user.lastLoginIP = req.ip;
    user.lastLoginAt = new Date();
    await user.save();
    
    // 6. 返回成功响应
    res.status(200).json({
      success: true,
      data: {
        token,
        user: {
          id: user._id,
          email: user.email,
          name: user.name
        }
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      error: { code: 'SERVER_ERROR', message: '服务器错误' }
    });
  }
};
```

**步骤 3: 接受或拒绝**

- **Accept**（本地模式）: 应用所有变更到工作区
- **Reject**（本地模式）: 丢弃所有变更（如果质量不达标）
- **Request Changes**: 要求 Agent 修复特定问题

```
用户：密码验证逻辑有问题，应该先检查账户锁定再验证密码
Agent: 好的，我会调整逻辑顺序...
```

### 26.9.6 经验总结

**成功因素**:
1. ✅ 需求清晰（EARS 格式）
2. ✅ 设计文档完整（接口定义、数据库设计、任务分解）
3. ✅ 中途添加需求（登录日志）
4. ✅ 自动验证（测试覆盖率高）
5. ✅ 代码审查（发现逻辑问题）

**改进建议**:
1. ⚠️ 应该更早提出登录日志需求（避免返工）
2. ⚠️ 应该添加性能基准测试（确保 1000 QPS）
3. ⚠️ 应该补充安全测试（OWASP Top 10）

**复用价值**:
- Spec 文档模板可用于其他认证功能（注册、忘记密码）
- 代码结构可用于其他 CRUD 功能
- 测试用例可作为参考模板

---

## 26.10 最佳实践总结

### 26.10.1 模式选择

- **简单任务 (<30min)**: 快速模式，直接描述需求
- **中等任务 (1-4h)**: 计划模式，需求澄清→生成计划→确认执行
- **复杂任务 (>4h)**: 规格模式，Requirements→Design→Task List

### 26.9.2 Spec 文档

- 使用 EARS 格式定义验收条件
- 包含功能需求、边界情况、非功能需求
- 存放在 `docs/specs/` 目录
- 通过 AGENTS.md 导航到 Spec 文档

### 26.9.3 项目结构

- 遵循标准项目结构（docs/, scripts/, .ai/）
- AGENTS.md 控制在 100 行左右
- 所有技术决策写入仓库
- 不依赖外部平台（Notion/Confluence）

### 26.9.4 自动化

- 配置 Hooks 实现自动验证
- pre-commit 确保提交质量
- post-edit 自动验证变更
- 自动修复最多 3 次，失败后请求人工介入

### 26.9.5 Harness Engineering

- 人类设计环境（项目结构 + 规范）
- 明确意图（Spec + EARS）
- 构建反馈回路（验证 + 自愈）
- Agent 在 Harness 体系中可靠工作

---

## 本章小结

AI Coding 最佳实践提供了完整的 AI 辅助编程方法论：

**核心框架**:
- **模式选择**: 根据任务复杂度选择快速/计划/规格模式
- **Spec-Driven**: 需求→设计→执行的三阶段流程
- **项目规范**: 标准结构确保知识可见性
- **自动化**: Hooks + 自动修复减少人工干预
- **Harness Engineering**: 设计环境让 Agent 可靠工作

**关键理念**:
> 人类不再写代码，而是设计环境、明确意图、构建反馈回路。

**下一步**:
- 第 27 章将应用这些最佳实践到漫剧项目
- 创建标准项目结构和 AGENTS.md
- 编写 Spec 文档示例

---

## 涉及面试题

1. **如何根据任务复杂度选择合适的 AI 编程模式？**
   - 简单任务 (<30min) → 快速模式
   - 中等任务 (1-4h) → 计划模式
   - 复杂任务 (>4h) → 规格模式

2. **Spec-Driven Development 的核心流程是什么？**
   - Requirements（需求）→ Design（设计）→ Implementation（执行）
   - 使用 EARS 格式定义验收条件

3. **如何设计 AI Coding 项目结构以确保知识可见性？**
   - docs/ 存储所有文档
   - scripts/ 存储验证脚本
   - .ai/ 存储 AI 配置
   - AGENTS.md 提供导航

4. **Harness Engineering 的三组件是什么？**
   - 设计环境（项目结构 + 规范）
   - 明确意图（Spec + EARS）
   - 构建反馈回路（验证 + 自愈）

---

**知识来源**:
- Qoder Quest Mode 官方文档
- OpenAI Harness Engineering 技术报告
- Anthropic Agent Engineering 最佳实践
- EARS 需求工程标准
- 用户提供 的 14 个核心知识点

---

**修改记录**:
- v3.0 (2026-03-27): AI Coding 通用知识整合版 - 整合 14 个核心知识点
- v2.6 (2026-03-26): Spec-Driven Development 补充版 - 新增规格驱动开发内容
- v2.5 (2026-03-23): 全书完成版
