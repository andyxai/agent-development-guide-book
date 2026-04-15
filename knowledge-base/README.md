# 知识库 - Agent 开发知识来源

> 收集、整理网络上优质的 Agent 开发相关文章，作为书籍内容的知识来源，也可独立阅读。

---

## 📁 目录结构

```
knowledge-base/
├── README.md              # 本文件 - 知识库索引
├── rag/                   # RAG 相关
├── multi-agent/           # 多 Agent 协作
├── llm/                   # LLM 原理与应用
├── prompt-engineering/    # Prompt 工程
├── tool-use/              # 工具使用与 Function Calling
├── evaluation/            # 评测与评估
├── engineering/           # 工程实践
└── other/                 # 其他主题
```

---

## 📖 使用方式

### 1. 添加文章

每篇文章保存为 Markdown 格式，文件命名规范：

```
YYYY-MM-DD-文章主题简述.md
```

示例：`2026-04-15-graph-rag-best-practices.md`

### 2. 文章元数据

每篇文章头部添加 YAML front matter：

```yaml
---
title: "文章标题"
author: "作者"
source: "原文链接"
date: "2026-04-15"
tags: ["rag", "graph-rag", "检索"]
related_chapters: ["04-02-高级 RAG 技术"]
summary: "一句话摘要"
---
```

### 3. 标签说明

| 标签 | 说明 |
|------|------|
| rag | RAG 相关技术 |
| multi-agent | 多 Agent 协作 |
| llm | LLM 原理、训练、优化 |
| prompt | Prompt 工程 |
| tool-use | 工具使用、Function Calling |
| evaluation | 评测、评估 |
| engineering | 工程实践、架构 |
| memory | 记忆系统 |
| planning | 规划与推理 |
| framework | 框架使用 |

---

## 📊 文章索引

### RAG 相关

| 日期 | 标题 | 标签 | 关联章节 |
|------|------|------|---------|
| *(待添加)* | | | |

### 工程实践

| 日期 | 标题 | 标签 | 关联章节 |
|------|------|------|---------||
| 2026-04-15 | Best Practices for Claude Code | engineering, context-management | 06-01, 06-03 |

### 多 Agent 协作

| 日期 | 标题 | 标签 | 关联章节 |
|------|------|------|---------||
| 2026-04-15 | Effective harnesses for long-running agents | multi-agent, harness-engineering | 06-02, 03-03 |

---

## 🔍 检索方式

### 按主题

直接浏览对应主题目录。

### 按标签

```bash
grep -r "tags:.*rag" docs/knowledge-base/
```

### 按关联章节

```bash
grep -r "related_chapters:.*04-02" docs/knowledge-base/
```

### 按时间

文件名按日期排序，可直接浏览。

---

## 📝 维护规范

1. **及时添加**：看到好文章立即保存
2. **完整元数据**：填写所有元数据字段
3. **准确关联**：标注与书籍章节的对应关系
4. **定期整理**：每月检查一次，删除低质量内容
5. **保持更新**：文章内容有过时标注时及时更新

---

**创建时间**: 2026-04-15  
**维护者**: andyxi
