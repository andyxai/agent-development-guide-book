# book_writer 项目状态

**位置**: `/Users/andy.zx/qoder/book/book-writer/`  
**状态**: ✅ 已初始化为 git 仓库  
**远程仓库**: `git@github.com:andyxai/book-writer.git`

---

## 项目定位

**通用书籍创作能力库**:
- 适用于所有书籍发布项目
- 包含通用规范、技能、模板
- 独立的 git 仓库，便于管理

---

## Git 配置

**本地仓库**: ✅ 已初始化  
**远程仓库**: `git@github.com:andyxai/book-writer.git`  
**分支**: main  
**首次提交**: 63f62bb feat: 初始化 book_writer 通用书籍创作能力库

---

## 核心文档

### 规范类 (rules/)
- 01-depth-requirements.md - 深度要求规则
- 02-formatting-rules.md - 排版规范规则
- 03-git-commit-rules.md - Git 提交规则
- 04-version-control.md - 版本管理规则
- 05-quality-standards.md - 质量标准规则
- 06-quality-assurance.md - 质量保障体系
- 07-file-organization-rules.md - 文件组织规范
- 08-pdf-generation-rules.md - PDF 生成规范

### 技能类 (skills/)
- 01-outline-writing.md - 大纲编写技能
- 02-detailed-outline.md - 细纲编写技能
- 03-content-writing.md - 正文编写技能
- 04-technical-review.md - 技术审核技能
- 05-editorial-review.md - 编辑统筹技能
- 06-revision.md - 修改完善技能
- 07-team-management.md - 专家团队管理

### 模板类 (templates/)
- 01-chapter-template.md - 章节模板
- 02-review-template.md - 审查报告模板
- 03-git-commit-template.md - Git 提交模板

### 经验总结
- **EXPERIENCE-SUMMARY.md** - 书籍发布经验总结 (通用)
- large-scale-update-experience.md - 大规模更新经验

### 指南
- BOOK_WRITER_GUIDE.md - 通用写书经验指南

---

## 与具体项目的关系

**book_writer/**: 通用能力库 (独立 git 仓库)
- 所有书籍项目共享
- 不包含具体书籍内容
- 持续更新和改进
- 通过 git 管理版本

**具体项目**: 独立 git 仓库
- 使用 book_writer 的规范和技能
- 包含具体书籍内容
- 可以 submodule 或手动同步

**发布项目**: 独立 git 仓库
- 使用 book_writer 的发布规范
- 只包含 PDF 文件
- 独立的 git 仓库

---

## 使用方式

### 方式 1: Git Submodule (推荐)

```bash
# 在新书籍项目中添加 submodule
git submodule add git@github.com:andyxai/book-writer.git book_writer

# 更新 submodule
git submodule update --remote
```

**优点**:
- 自动同步 book_writer 更新
- 版本可控
- 易于管理

### 方式 2: 手动同步

```bash
# 复制 book_writer 到项目中
cp -r ../book_writer ./

# 或使用 rsync
rsync -av ../book_writer/ ./book_writer/
```

**优点**:
- 简单直接
- 不依赖 submodule

### 方式 3: 引用文档

在项目 README 中引用：

```markdown
## 写作规范

参考 [book_writer/rules/](../book_writer/rules/)

## 发布流程

参考 [book_writer/EXPERIENCE-SUMMARY.md](../book_writer/EXPERIENCE-SUMMARY.md)
```

---

## 更新流程

### 更新 book_writer 规范

1. 在 book_writer 仓库中修改规范文档
2. Git 提交并推送
3. 在具体项目中更新：
   ```bash
   git submodule update --remote  # submodule 方式
   # 或手动复制更新
   ```
4. 测试新规范在具体项目中可行
5. 更新相关项目的文档

### 同步最佳实践

- 定期 (每月) 检查 book_writer 更新
- 在新项目开始前同步最新规范
- 记录项目中使用的 book_writer 版本
- 反馈改进建议到 book_writer 项目

---

## 维护者

**维护者**: book_writer 项目组  
**最后更新**: 2026-03-23  
**状态**: ✅ 已初始化为 git 仓库  
**适用范围**: 所有书籍发布项目
