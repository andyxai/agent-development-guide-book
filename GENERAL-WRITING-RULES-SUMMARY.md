# 通用写书规范整理记录

**整理时间**: 2026-03-23  
**整理人**: 主编（小助手）

---

## 整理的规范文档

### 1. 文件组织规范

**文件**: `book_writer/rules/07-file-organization-rules.md`  
**版本**: v1.0  
**状态**: ✅ 必须遵循

**核心规则**:
1. 项目内容统一原则：项目产出的所有内容必须统一放在项目目录下
2. 目录结构清晰原则：使用标准目录结构，保持清晰合理
3. Git 版本控制原则：所有文件必须纳入 Git 版本控制

**标准目录结构**:
```
{book-project}/
├── README.md
├── VERSION.md
├── dev/
│   ├── drafts/          # 章节草稿
│   ├── guides/          # 写作指南
│   ├── research/        # 调研报告
│   ├── temp/            # 临时工作文件
│   └── reviews/         # 审核报告
└── docs/                # 正式文档
```

---

### 2. PDF 生成规范

**文件**: `book_writer/rules/08-pdf-generation-rules.md`  
**版本**: v1.1 (添加作者和状态规范)  
**状态**: ✅ 必须遵循

**触发条件**: 总编说"可以对外发布了"

**核心规则**:
1. 总编确认原则：必须总编确认后才能生成 PDF
2. 批量生成原则：所有章节全部生成，不单独生成
3. 质量检查原则：检查合格后才发布
4. Git 管理原则：PDF 文件纳入 Git 管理
5. 作者统一原则：所有 PDF 作者为 {作者名} (如 andyxi)
6. 状态标注原则：所有 PDF 状态为"等待用户反馈修改"

**PDF 生成步骤**:
```
总编确认"可以对外发布了"
    │
    ▼
1. 检查 docs/v{版本号}/md/ 目录
    │
    ▼
2. 创建 docs/v{版本号}/pdf/ 目录
    │
    ▼
3. 批量生成 PDF (pandoc + xeLaTeX)
    │
    ├── 作者：{作者名}
    ├── 状态：等待用户反馈修改
    └── 保持文件名一致 (中文名称)
    │
    ▼
4. 质量检查
    │
    ├── PDF 数量 = Markdown 数量
    ├── 文件名一致性
    └── 格式检查 (封面、目录、页码)
    │
    ▼
5. Git 提交并推送
    │
    ▼
6. 更新 docs/README.md
    │
    ▼
7. 发布完成
```

**PDF 元数据规范**:
- **作者**: {作者名} (如 andyxi)
- **状态**: 等待用户反馈修改
- **封面页**: 包含书名、章节标题、版本、作者、状态
- **页脚**: {章节标题} | {作者名} | 等待用户反馈修改 | 第 {页码} 页

**推荐工具**:
- ✅ pandoc + xeLaTeX (支持中文、格式美观)
- markdown-pdf (简单易用)

---

## 项目应用

### agent-development-advanced-guide 项目

**已应用规范**:
1. ✅ 文件组织规范 (已整理目录结构)
2. ✅ PDF 生成规范 (已创建 PDF-GENERATION-RECORD.md)

**项目特定配置**:
- 作者名：andyxi
- 状态标注：等待用户反馈修改
- 当前版本：v2.6
- 章节数：25 章

**文档位置**:
- `docs/PDF-GENERATION-RECORD.md`: PDF 生成记录
- `dev/guides/release-rules.md`: 版本发布规范

---

## 总结

### 通用规范 (book_writer/)

| 规范 | 文件 | 适用范围 |
|------|------|---------|
| 文件组织规范 | rules/07-file-organization-rules.md | 所有写书项目 |
| PDF 生成规范 | rules/08-pdf-generation-rules.md | 所有写书项目 |

### 项目特定规范 (agent-development-advanced-guide/)

| 规范 | 文件 | 适用范围 |
|------|------|---------|
| 版本发布规范 | dev/guides/release-rules.md | 本项目 |
| PDF 生成记录 | docs/PDF-GENERATION-RECORD.md | 本项目 v2.6 |

---

**维护者**: 主编（小助手）  
**最后更新**: 2026-03-23  
**状态**: ✅ 已完成
