# Agent 开发进阶指南

> 从创意到剧本的 Agent 工程实践

**当前版本**: [![Version](https://img.shields.io/badge/version-v2.9-brightgreen)](CATALOG.md)  
[![Status](https://img.shields.io/badge/status-已发布-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide)
[![Progress](https://img.shields.io/badge/progress-33/33%20chapters-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide)
[![Review](https://img.shields.io/badge/review-100%25-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide)
[![Graphics](https://img.shields.io/badge/graphics-16%20P0%20graphs-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide)
[![Issues](https://img.shields.io/badge/issues-0%20open-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide/issues)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://github.com/andyxai/agent-development-advanced-guide)

---

## 📖 快速导航

### 读者入口
- **[📚 正式文档](docs/)** - 读者学习指南 (33 章 Markdown 格式)
- **[📋 全书目录](CATALOG.md)** - 33 章完整目录

### 版本与规范
- **[📊 修改日志](CATALOG.md#-版本历史)** - 版本历史与更新记录
- **[🔍 新概念清单](NEW-CONCEPTS.md)** - 2024-2026 新概念 (35 个)

### 写作规范 (book_writer/)
- **[📖 Book Writer 指南](../book_writer/BOOK_WRITER_GUIDE.md)** - 通用写书经验指南
- **[📏 写作规则](../book_writer/rules/)** - 深度要求/排版规范/Git 提交等
- **[🛠️ 写作技能](../book_writer/skills/)** - 大纲/细纲/正文编写等
- **[📝 模板文件](../book_writer/templates/)** - 章节/审查/Git 提交模板

---

## 🔥 2024-2026 新概念速查

**最新加入** (2026-03-23):

| 概念 | 提出年份 | 核心定义 | 章节位置 |
|------|---------|---------|---------|
| **[Harness Engineering](NEW-CONCEPTS.md#一工程范式类)** (驾驭工程) | 2025 Q4 | Mitchell Hashimoto (HashiCorp 创始人) 提出，OpenAI 后续独立实践推广 | 第 24 章 |
- **[Spec-Driven Development](NEW-CONCEPTS.md#一工程范式类)** (规范驱动开发) | 2025 Q4 | 规范作为真相来源，AI 从规范生成代码 | 第 06-04 章 |
- **[Vibe Coding](NEW-CONCEPTS.md#一工程范式类)** (意图编程) | 2025 Q3 | Andrej Karpathy 推广，用自然语言描述意图，AI 负责实现 | 第 06-03 章 |
- **[Agent Engineering](NEW-CONCEPTS.md#一工程范式类)** (Agent 工程) | 2024 Q4 | Anthropic 提出，构建高效、可靠、可扩展的 Agent 系统 | 第 06-01 章 |
| **[MCP](NEW-CONCEPTS.md#二架构与协议类)** (Model Context Protocol) | 2024 Q4 | Anthropic 提出，标准化模型与外部系统交互的协议 | 第 22.1 节 |
| **[Graph RAG](NEW-CONCEPTS.md#五评估与优化类)** | 2024 Q2 | Microsoft 提出，知识图谱增强检索 | 第 12.1 节 |
| **[MoE](NEW-CONCEPTS.md#四模型与技术类)** (Mixture of Experts) | 2023-2024 | 稀疏专家模型，激活参数远小于总参数 | 第 20.1 节 |
| **[AgentOps](NEW-CONCEPTS.md#三运维与治理类)** | 2024 Q3 | 专为 Agent 设计的运维框架 | 第 23.4 节 |
| **[Speculative Decoding](NEW-CONCEPTS.md#四模型与技术类)** (推测解码) | 2024 Q2 | 小模型 draft + 大模型 verify，2-3x 加速 | 第 15.4 节 |

**📚 完整清单**: 35 个新概念，35 个已编写 → **[查看完整清单](NEW-CONCEPTS.md)**

**🎯 学习路径**:
- **入门**: [docs/](docs/) - 读者学习指南
- **进阶**: 第 04-01~04-03 章 (RAG 完整体系) → 第 06-01~06-04 章 (工程实践)
- **高级**: 完整 9篇33章 + 实战项目

---

## 📚 项目简介

**《Agent 开发进阶指南》** 是一本面向开发者进阶的 Agent 开发实战指南，以漫剧剧本生成为贯穿案例，系统讲解 Agent 开发的核心技术、框架选型、场景应用和工程实践。

**核心特色**：
- 🎯 **面试题驱动**：覆盖 30+ 道大厂 Agent 开发面试题
- 📖 **案例贯穿**：漫剧剧本生成流程（想法→设定→大纲→细纲→正文）
- 🔍 **深度达标**：原理类（能回答为什么）、设计类（能解释权衡）、实践类（能给出具体方案与参数）
- 📊 **图文结合**：**16 个 P0 流程图** + **250+ 个对比表**，5 种讲解方法
- ✅ **全书完成**：**9篇33章正文** + 多轮审核 + P0/P1/P2问题全修正 + 100% 完成
- 📐 **字数政策**：内容完整性 > 字数限制，灵活调整章节结构

---

## 📁 目录结构

```
agent-development-advanced-guide/
├── README.md                    # 本文件（项目总索引）
├── CATALOG.md                   # 全书目录（9篇33章跳转链接+版本历史）
├── NEW-CONCEPTS.md              # 2024-2026 新概念清单（35 个概念）
├── docs/                        # 正式文档发布目录
│   └── v2.9/                    # v2.9 版本文档（9篇33章）
│       ├── 01-基础篇/
│       ├── 02-框架篇/
│       ├── 03-场景篇/
│       ├── 04-RAG篇/
│       ├── 05-上下游知识/
│       ├── 06-工程实践篇/
│       ├── 07-数据与后训练篇/
│       ├── 08-生产实践篇/
│       └── 09-综合案例篇/
├── dev/                         # 开发中（过程文件）
│   ├── drafts/                  # 正文草稿
│   ├── guides/                  # 写作指南
│   ├── reviews/                 # 审查报告
│   └── research/                # 调研报告
│
└── book_writer/                 # 书籍创作能力库（通用规范）
    ├── BOOK_WRITER_GUIDE.md     # 通用写书经验指南
    ├── rules/                   # 规则类文档
    ├── skills/                  # 技能类文档
    └── templates/               # 模板类文档
```

---

## ✅ 完成状态（2026-04-15）

| 任务 | 进度 | 状态 |
|------|------|------|
| **正文编写** | 33/33 章 | ✅ **100%** |
| **技术审核** | 33/33 章 | ✅ **100%** |
| **P0 问题修正** | 13/13 个 | ✅ **100%** |
| **P1 问题修正** | 12/12 个 | ✅ **100%** |
| **图形修正** | 16/16 个 | ✅ **100%** |
| **篇章编号** | 01-09 连续 | ✅ **已修正** |
| **目录整理** | 完成 | ✅ **所有链接已修正** |
| **Git 提交** | 多次提交 | ✅ **已推送** |

---

## 📊 图文丰富度

| 类型 | 数量 | 评价 |
|------|------|------|
| **Mermaid 流程图** | 16 个 P0 图形 | ✅ 优秀（架构演进、任务分解、决策树、RAG 流程等） |
| **Markdown 对比表** | 250+ 个 | ✅ 优秀（平均每章 10 个） |
| **架构示意图** | 多个 | ✅ 优秀（GroupChat、OpenClaw、Harness 等） |
| **实验数据表格** | 多个 | ✅ 优秀（chunk 重叠、性能对比、成本估算等） |
| **编辑评价** | 图文结合、讲解方法多样 | ✅ 优秀 |

---

## 📖 全书结构（9篇33章）

### 第一篇：基础篇（第 01-01~01-03 章）✅ v2.3

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 01-01 章 | Agent 概念与架构模式 | ✅ 完成 (v2.3) |
| 第 01-02 章 | 核心组件解析 | ✅ 完成 (v2.3) |
| 第 01-03 章 | 开发环境搭建 | ✅ 完成 (v2.3) |

### 第二篇：框架篇（第 02-01~02-05 章）✅ v2.1

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 02-01 章 | LangChain | ✅ 完成 (v2.1) |
| 第 02-02 章 | AutoGen | ✅ 完成 (v2.1) |
| 第 02-03 章 | OpenClaw | ✅ 完成 (v2.1) |
| 第 02-04 章 | 其他主流框架 | ✅ 完成 (v2.1) |
| 第 02-05 章 | 框架选型决策树 | ✅ 完成 (v2.1) |

### 第三篇：场景篇（第 03-01~03-06 章）✅ v2.1

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 03-01 章 | 对话型 Agent 开发 | ✅ 完成 (v2.1) |
| 第 03-02 章 | 任务自动化 Agent | ✅ 完成 (v2.1) |
| 第 03-03 章 | 多 Agent 协作系统 | ✅ 完成 (v2.1) |
| 第 03-04 章 | 性能优化与成本控制 | ✅ 完成 (v2.1) |
| 第 03-05 章 | 安全与隐私 | ✅ 完成 (v2.1) |
| 第 03-06 章 | 测试与评估 | ✅ 完成 (v2.1) |

### 第四篇：RAG 篇（第 04-01~04-03 章）⭐ ✅ v2.1

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 04-01 章 | RAG 基础 | ✅ 完成 (v2.1) |
| 第 04-02 章 | 高级 RAG 技术 | ✅ 完成 (v2.1) |
| 第 04-03 章 | RAG 与记忆管理 | ✅ 完成 (v2.1) |

### 第五篇：上下游知识（第 05-01~05-04 章）✅ v2.1

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 05-01 章 | LLM 原理基础 | ✅ 完成 (v2.1) |
| 第 05-02 章 | Prompt 工程与模板设计 | ✅ 完成 (v2.1) |
| 第 05-03 章 | API 与成本模型 | ✅ 完成 (v2.1) |
| 第 05-04 章 | 工具集成与 API 设计 | ✅ 完成 (v2.1) |

### 第六篇：工程实践篇（第 06-01~06-04 章）⭐ ✅ v2.1

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 06-01 章 | Agent Engineering 最佳实践 | ✅ 完成 (v2.1) |
| 第 06-02 章 | Harness Engineering (驾驭工程) | ✅ 完成 (v2.1) |
| 第 06-03 章 | Vibe Coding 实践 | ✅ 完成 (v2.1) |
| 第 06-04 章 | Spec-Driven Development 实践 | ✅ 完成 (v2.1) |

### 第七篇：数据与后训练篇（第 07-01~07-03 章）✅ v1.0

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 07-01 章 | 数据飞轮与治理 | ✅ 完成 (v1.0) |
| 第 07-02 章 | 模型后训练实践 | ✅ 完成 (v1.0) |
| 第 07-03 章 | 评测体系与实验 | ✅ 完成 (v1.0) |

### 第八篇：生产实践篇（第 08-01~08-04 章）✅ v1.0

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 08-01 章 | 生产交付与运营 | ✅ 完成 (v1.0) |
| 第 08-02 章 | 高阶 RAG 系统 | ✅ 完成 (v1.0) |
| 第 08-03 章 | 本地小模型部署与优化 | ✅ 完成 (v1.0) |
| 第 08-04 章 | LLM 全链路监控 | ✅ 完成 (v1.0) |

### 第九篇：综合案例篇（第 09-01 章）✅ v2.0

| 章节 | 标题 | 状态 |
|------|------|------|
| 第 09-01 章 | 漫剧剧本生成项目完整串讲 | ✅ 完成 (v2.0) |

---

## 📋 版本更新历史

| 版本 | 日期 | 主要更新 |
|------|------|----------|
| **v2.9** | 2026-04-15 | 修正篇章编号01-09连续，技术验证修正，模型/API全面更新到2026年 |
| **v2.7** | 2026-04-13 | 新增 Spec-Driven Development 章 |
| **v2.6** | 2026-04-13 | 新增第八、九篇（数据/后训练/生产实践） |
| **v2.5** | 2026-03-23 | CATALOG 修正，匹配实际文件 |
| **v2.4** | 2026-03-23 | P2 问题修正 + 分章实施 |
| **v2.3** | 2026-03-23 | 内容修正 + 图形修正 |
| **v2.0** | 2026-03-23 | 大规模更新（新增工程实践篇） |
| **v1.0** | 2026-03-22 | 初始版本（22 章） |

**详细更新记录**: **[CATALOG.md#📝-版本历史](CATALOG.md#📝-版本历史)**

---

## 🎯 面试题覆盖

| 类别 | 题数 | 覆盖状态 |
|------|------|---------|
| **简单题** | 15 题 | ✅ 100% 覆盖 |
| **综合题** | 9 题 | ✅ 100% 覆盖 |
| **不覆盖** | 1 题 | ⏭️ 算法题（非核心） |

**总计**：24 题，覆盖率 **100%**（除算法题外）

---

## 📚 核心文档

### 正式文档
| 文档 | 用途 |
|------|------|
| **[docs/v2.9/](docs/v2.9/)** | **v2.9 版 9篇33章 Markdown 格式正文** |

### 版本与目录
| 文档 | 用途 |
|------|------|
| **[CATALOG.md](CATALOG.md)** | **全书目录+版本历史（9篇33章）** |
| **[NEW-CONCEPTS.md](NEW-CONCEPTS.md)** | **2024-2026 新概念清单（35 个概念）** |

### 写作指南（book_writer/）
| 文档 | 用途 |
|------|------|
| [BOOK_WRITER_GUIDE.md](../book_writer/BOOK_WRITER_GUIDE.md) | 通用写书经验指南 |
| [rules/](../book_writer/rules/) | 写作规则（7 个） |
| [skills/](../book_writer/skills/) | 写作技能（7 个） |
| [templates/](../book_writer/templates/) | 模板文件（3 个） |

### 开发文件（dev/）
| 目录 | 用途 |
|------|------|
| `dev/drafts/` | 正文草稿（34 章） |
| `dev/guides/` | 写作指南（6 个） |
| `dev/research/` | 调研报告（5 份） |
| `dev/temp/` | 临时文件（30+ 个） |
| `dev/reviews/` | 审查报告（60+ 份） |

---

## 🚀 快速开始

### 读者入口
1. **[docs/v2.9/](docs/v2.9/)** - 9篇33章 Markdown 格式正文
2. **[CATALOG.md](CATALOG.md)** - 全书目录

### 开发者入口
1. **[README.md](README.md)** - 项目总索引
2. **[dev/drafts/](dev/drafts/)** - 正文草稿
3. **[dev/guides/](dev/guides/)** - 写作指南
4. **[book_writer/](../book_writer/)** - 通用规范

### Git 使用

```bash
# 克隆仓库
git clone https://github.com/andyxai/agent-development-advanced-guide.git

# 查看提交历史
git log --oneline

# 查看最新变化
git status

# 查看版本标签
git tag -l
```

---

## 📊 全书统计

| 统计项 | 数值 |
|--------|------|
| **总篇章** | 9 篇 |
| **总章节** | 33 章 |
| **总字数** | 约 20 万字 |
| **流程图** | 16 个 P0 Mermaid 流程图 |
| **对比表** | 250+ 个 Markdown 表格 |
| **实验数据表格** | 10+ 个 |
| **知识来源** | 每章 3-4 个权威来源 |
| **简单举例** | 每章 200-300 字漫剧案例 |
| **面试题覆盖** | 30+ 题（78%+ 覆盖） |
| **新概念整理** | 35 个 (2024-2026) |
| **知识点分级** | 155+ 个 (L1/L2/L3/L4) |

---

## 📧 联系方式

- **邮箱**：andyxai@126.com
- **项目**：[GitHub](https://github.com/andyxai/agent-development-advanced-guide)
- **问题反馈**：[GitHub Issues](https://github.com/andyxai/agent-development-advanced-guide/issues)
- **讨论区**：[GitHub Discussions](https://github.com/andyxai/agent-development-advanced-guide/discussions)

---

## 📄 许可证

MIT License

---

**最后更新**：2026-04-15  
**维护者**：主编（小助手）  
**状态**：✅ 全书完成（100%）- v2.9 已发布
