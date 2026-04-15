# Agent 开发进阶指南

> 从创意到剧本的 Agent 工程实践

**当前版本**: [![Version](https://img.shields.io/badge/version-v2.7-brightgreen)](VERSION.md)  
[![Status](https://img.shields.io/badge/status-已发布-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide)
[![Progress](https://img.shields.io/badge/progress-34/34%20chapters-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide)
[![Review](https://img.shields.io/badge/review-100%25-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide)
[![Graphics](https://img.shields.io/badge/graphics-16%20P0%20graphs-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide)
[![Issues](https://img.shields.io/badge/issues-0%20open-brightgreen)](https://github.com/andyxai/agent-development-advanced-guide/issues)
[![License](https://img.shields.io/badge/license-MIT-blue)](https://github.com/andyxai/agent-development-advanced-guide)

---

## 📖 快速导航

### 读者入口
- **[📚 正式文档](docs/)** - 读者学习指南 (34 章 Markdown 格式)
- **[📋 全书目录](CATALOG.md)** - 34 章完整目录

### 版本与规范
- **[📝 版本记录](VERSION.md)** - v2.7 版本历史与更新记录
- **[🔍 新概念清单](NEW-CONCEPTS.md)** - 2024-2026 新概念 (35 个)
- **[📊 修改日志](CHANGELOG.md)** - 完整修改日志

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
| **[Spec-Driven Development](NEW-CONCEPTS.md#一工程范式类)** (规范驱动开发) | 2025 Q4 | 规范作为真相来源，AI 从规范生成代码 | 第 26 章 |
| **[Vibe Coding](NEW-CONCEPTS.md#一工程范式类)** (意图编程) | 2025 Q3 | Andrej Karpathy 推广，用自然语言描述意图，AI 负责实现 | 第 25 章 |
| **[Agent Engineering](NEW-CONCEPTS.md#一工程范式类)** (Agent 工程) | 2024 Q4 | Anthropic 提出，构建高效、可靠、可扩展的 Agent 系统 | 第 23 章 |
| **[MCP](NEW-CONCEPTS.md#二架构与协议类)** (Model Context Protocol) | 2024 Q4 | Anthropic 提出，标准化模型与外部系统交互的协议 | 第 22.1 节 |
| **[Graph RAG](NEW-CONCEPTS.md#五评估与优化类)** | 2024 Q2 | Microsoft 提出，知识图谱增强检索 | 第 12.1 节 |
| **[MoE](NEW-CONCEPTS.md#四模型与技术类)** (Mixture of Experts) | 2023-2024 | 稀疏专家模型，激活参数远小于总参数 | 第 20.1 节 |
| **[AgentOps](NEW-CONCEPTS.md#三运维与治理类)** | 2024 Q3 | 专为 Agent 设计的运维框架 | 第 23.4 节 |
| **[Speculative Decoding](NEW-CONCEPTS.md#四模型与技术类)** (推测解码) | 2024 Q2 | 小模型 draft + 大模型 verify，2-3x 加速 | 第 15.4 节 |

**📚 完整清单**: 35 个新概念，35 个已编写 → **[查看完整清单](NEW-CONCEPTS.md)**

**🎯 学习路径**:
- **入门**: [docs/](docs/) - 读者学习指南
- **进阶**: 第 11-13 章 (RAG 完整体系) → 第 23-26 章 (工程实践)
- **高级**: 完整 34 章 + 实战项目

---

## 📚 项目简介

**《Agent 开发进阶指南》** 是一本面向开发者进阶的 Agent 开发实战指南，以漫剧剧本生成为贯穿案例，系统讲解 Agent 开发的核心技术、框架选型、场景应用和工程实践。

**核心特色**：
- 🎯 **面试题驱动**：覆盖 24 道大厂 Agent 开发面试题
- 📖 **案例贯穿**：漫剧剧本生成流程（想法→设定→大纲→细纲→正文）
- 🔍 **深度达标**：原理类（能回答为什么）、设计类（能解释权衡）、实践类（能给出具体方案与参数）
- 📊 **图文结合**：**16 个 P0 流程图** + **250+ 个对比表**，5 种讲解方法
- ✅ **全书完成**：**34 章正文** + 多轮审核 + P0/P1/P2问题全修正 + 100% 完成
- 📐 **字数政策**：内容完整性 > 字数限制，灵活调整章节结构

---

## 📁 目录结构

```
agent-development-advanced-guide/
├── README.md                    # 本文件（项目总索引）
├── VERSION.md                   # 版本更新记录（当前 v2.6）
├── CATALOG.md                   # 全书目录（34 章跳转链接）
├── NEW-CONCEPTS.md              # 2024-2026 新概念清单（35 个概念）
├── CHANGELOG.md                 # 完整修改日志
├── docs/                        # 正式文档发布目录
│   ├── README.md                # 读者学习指南
│   └── v2.7/                    # v2.7 版本文档
│       ├── md/                  # Markdown 格式（34 章）
│       └── pdf/                 # PDF 格式（待生成）
├── dev/                         # 开发中（过程文件）
│   ├── drafts/                  # 正文草稿（34 份：34 章）
│   ├── guides/                  # 写作指南（6 份）
│   ├── research/                # 调研报告（5 份）
│   ├── temp/                    # 临时文件（30+ 个）
│   ├── reviews/                 # 审查报告（60+ 份）
│   └── reports/                 # 专家报告
│
└── book_writer/                 # 书籍创作能力库（通用规范）
    ├── BOOK_WRITER_GUIDE.md     # 通用写书经验指南
    ├── rules/                   # 规则类文档（7 个）
    ├── skills/                  # 技能类文档（7 个）
    └── templates/               # 模板类文档（3 个）
```

---

## ✅ 完成状态（2026-03-23 14:45）

| 任务 | 进度 | 状态 |
|------|------|------|
| **正文编写** | 34/34 章 | ✅ **100%** |
| **技术审核** | 25/25 章 | ✅ **100%** |
| **P0 问题修正** | 19/19 个 | ✅ **100%** |
| **P1 问题修正** | 56/56 个 | ✅ **100%** |
| **P2 问题修正** | 23/23 个 | ✅ **100%** |
| **图形修正** | 16/16 个 | ✅ **100%** |
| **分章实施** | 完成 | ✅ **第 11 章拆分为 11-13 章** |
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

## 📖 全书结构（34 章）

### 第一篇：基础篇（第 1-3 章）✅ v2.3

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 1 章 | Agent 概念与架构模式 | ~5,000 | ✅ 完成 (v2.3) |
| 第 2 章 | 核心组件解析 | ~6,000 | ✅ 完成 (v2.3) |
| 第 3 章 | 开发环境搭建 | ~5,000 | ✅ 完成 (v2.3) |

### 第二篇：框架篇（第 4-8 章）✅ v2.1

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 4 章 | LangChain | ~6,000 | ✅ 完成 (v2.1) |
| 第 5 章 | AutoGen | ~7,000 | ✅ 完成 (v2.1) |
| 第 6 章 | OpenClaw | ~6,000 | ✅ 完成 (v2.1) |
| 第 7 章 | 其他主流框架 | ~7,000 | ✅ 完成 (v2.1) |
| 第 8 章 | 框架选型决策树 | ~6,000 | ✅ 完成 (v2.1) |

### 第三篇：场景篇（第 9-10 章）✅ v2.1

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 9 章 | 对话型 Agent 开发 | ~6,000 | ✅ 完成 (v2.1) |
| 第 10 章 | 任务自动化 Agent | ~6,000 | ✅ 完成 (v2.1) |

### 第四篇：RAG 篇（第 11-13 章）⭐ ✅ v2.1

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 11 章 | RAG 基础 | ~5,000 | ✅ 完成 (v2.1) |
| 第 12 章 | 高级 RAG 技术 | ~6,500 | ✅ 完成 (v2.1) |
| 第 13 章 | RAG 与记忆管理 | ~4,000 | ✅ 完成 (v2.1) |

### 第五篇：进阶篇（第 14-18 章）✅ v2.1

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 14 章 | 多 Agent 协作系统 | ~6,000 | ✅ 完成 (v2.1) |
| 第 15 章 | 性能优化与成本控制 | ~7,000 | ✅ 完成 (v2.1) |
| 第 16 章 | 安全与隐私 | ~7,000 | ✅ 完成 (v2.1) |
| 第 17 章 | 测试与评估 | ~6,000 | ✅ 完成 (v2.1) |
| 第 18 章 | 漫剧剧本生成项目完整串讲 | ~8,000 | ✅ 完成 (v2.1) |

### 第六篇：上下游知识（第 19-22 章）✅ v2.1

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 19 章 | LLM 原理基础 | ~6,000 | ✅ 完成 (v2.1) |
| 第 20 章 | Prompt 工程与模板设计 | ~6,000 | ✅ 完成 (v2.1) |
| 第 21 章 | API 与成本模型 | ~6,000 | ✅ 完成 (v2.1) |
| 第 22 章 | 工具集成与 API 设计 | ~6,000 | ✅ 完成 (v2.1) |

### 第七篇：工程实践篇（第 23-26 章）⭐ ✅ v2.1

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 23 章 | Agent Engineering 最佳实践 | ~8,000 | ✅ 完成 (v2.1) |
| 第 24 章 | Harness Engineering (驾驭工程) | ~8,000 | ✅ 完成 (v2.1) |
| 第 25 章 | Vibe Coding 实践 | ~6,000 | ✅ 完成 (v2.1) |
| 第 26 章 | Spec-Driven Development 实践 | ~5,000 | ✅ 完成 (v1.0) |

### 第八篇：数据与后训练篇（第 27-29 章）✅ v1.0

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 27 章 | 数据飞轮与治理 | ~5,500 | ✅ 完成 (v1.0) |
| 第 28 章 | 模型后训练实践 | ~5,500 | ✅ 完成 (v1.0) |
| 第 29 章 | 评测体系与实验 | ~5,000 | ✅ 完成 (v1.0) |

### 第九篇：生产实践篇（第 30-33 章）✅ v1.0

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 30 章 | 生产交付与运营 | ~5,500 | ✅ 完成 (v1.0) |
| 第 31 章 | 高阶 RAG 系统 | ~5,500 | ✅ 完成 (v1.0) |
| 第 32 章 | 本地小模型部署与优化 | ~5,000 | ✅ 完成 (v1.0) |
| 第 33 章 | LLM 全链路监控 | ~5,000 | ✅ 完成 (v1.0) |

### 第十篇：综合案例篇（第 34 章）✅ v2.0

| 章节 | 标题 | 字数 | 状态 |
|------|------|------|------|
| 第 34 章 | 漫剧剧本生成项目完整串讲 | ~8,000 | ✅ 完成 (v2.0) |

---

## 📋 版本更新历史

| 版本 | 日期 | 主要更新 | 文件变更 |
|------|------|---------|---------|
| **v2.7** | 2026-04-13 | 新增第 26 章 Spec-Driven Development，章节编号调整为 34 章 | 10+ 文件 |
| **v2.6** | 2026-03-23 | 章节文件版本号统一、docs 目录发布 | 53 个文件 |
| **v2.5** | 2026-03-23 | CATALOG 修正，匹配实际文件 | 1 个文件 |
| **v2.4** | 2026-03-23 | P2 问题修正 + 分章实施 | 30+ 文件 |
| **v2.3** | 2026-03-23 | 内容修正 + 图形修正 | 30+ 文件 |
| **v2.0** | 2026-03-23 | 大规模更新 (新增第 23-24 章) | 50+ 文件 |
| **v1.0** | 2026-03-22 | 初始版本 (22 章) | - |

**详细更新记录**: **[VERSION.md](VERSION.md)**

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
| **[docs/README.md](docs/)** | **读者学习指南 (34 章 Markdown)** |
| **[docs/v2.7/md/](docs/v2.7/md/)** | **v2.7 版 Markdown 格式正文** |

### 版本与目录
| 文档 | 用途 |
|------|------|
| **[VERSION.md](VERSION.md)** | **版本更新记录（当前 v2.7）** |
| **[CATALOG.md](CATALOG.md)** | **全书目录（34 章跳转链接）** |
| **[NEW-CONCEPTS.md](NEW-CONCEPTS.md)** | **2024-2026 新概念清单（35 个概念）** |
| **[CHANGELOG.md](CHANGELOG.md)** | **完整修改日志** |

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
1. **[docs/README.md](docs/)** - 读者学习指南
2. **[docs/v2.7/md/](docs/v2.7/md/)** - 34 章 Markdown 格式正文
3. **[CATALOG.md](CATALOG.md)** - 全书目录

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
| **总章节** | 34 章 |
| **总字数** | 约 20 万字 |
| **流程图** | 16 个 P0 Mermaid 流程图 |
| **对比表** | 250+ 个 Markdown 表格 |
| **实验数据表格** | 10+ 个 |
| **知识来源** | 每章 3-4 个权威来源 |
| **简单举例** | 每章 200-300 字漫剧案例 |
| **面试题覆盖** | 24 题（100% 覆盖） |
| **新概念整理** | 35 个 (2024-2026) |
| **知识点分级** | 155+ 个 (L1/L2/L3/L4) |
| **Git 提交** | 多次提交 |

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

**最后更新**：2026-04-13  
**维护者**：主编（小助手）  
**状态**：✅ 全书完成（100%）- v2.7 已发布
