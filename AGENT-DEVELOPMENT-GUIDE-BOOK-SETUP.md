# agent-development-guide-book 发布项目设置记录

**创建时间**: 2026-03-23  
**项目位置**: `book/agent-development-guide-book/`  
**远程仓库**: https://github.com/andyxai/agent-development-guide-book.git

---

## 项目定位

**对外发布书籍 PDF 版本的官方仓库**

- 只包含正式发布的 PDF 文件
- 按版本号组织 (v2.6/, v2.5/, ...)
- 提供打包下载和单章下载
- README 指导用户阅读最新版本

---

## 目录结构

```
agent-development-guide-book/
├── README.md                    # 发布指南 (下载链接、阅读指南)
├── PUBLISH-GUIDE.md             # 发布流程规范
├── v2.6/                        # v2.6 版本
│   ├── pdf/                     # PDF 文件 (25 章)
│   │   ├── 01-Agent 概念与架构模式.pdf
│   │   ├── 02-核心组件解析.pdf
│   │   └── ...
│   └── agent-guide-v2.6.zip     # 打包下载
├── v2.5/                        # v2.5 版本
└── ...
```

---

## 发布流程

### 触发条件

**总编指令**: "可以对外发布了"

### 发布步骤

```
总编确认"可以对外发布了"
    │
    ▼
1. 检查 agent-development-advanced-guide 项目
    │
    └── docs/v{版本号}/pdf/ 目录已生成全部 PDF
    │
    ▼
2. 复制 PDF 文件
    │
    ├── 来源：book/agent-development-advanced-guide/docs/v{版本号}/pdf/
    └── 目标：book/agent-development-guide-book/v{版本号}/pdf/
    │
    ▼
3. 创建打包文件
    │
    └── cd v{版本号} && zip -r agent-guide-v{版本号}.zip pdf/
    │
    ▼
4. 更新 README.md
    │
    ├── 更新最新版本号
    ├── 添加下载链接
    └── 更新版本历史表格
    │
    ▼
5. Git 提交并推送
    │
    ├── git add -A
    ├── git commit -m "release: 发布 v{版本号} PDF 版本"
    └── git push origin main
    │
    ▼
6. 发布完成
```

---

## 已创建文件

### README.md

**内容**:
- 下载最新版本 (v2.6)
- 25 章 PDF 文件列表和下载链接
- 推荐阅读顺序 (4 种学习路径)
- 版本历史表格
- PDF 文件说明
- 联系方式

### PUBLISH-GUIDE.md

**内容**:
- PDF 发布流程规范
- 目录结构规范
- 自动化脚本 (release-pdf.sh)
- README 更新指南
- Git 提交规范
- 检查清单
- 注意事项

---

## Git 设置

**本地仓库**:
```bash
cd /home/admin/openclaw/workspace/book/agent-development-guide-book
git init
git config user.email "andyxai@126.com"
git config user.name "andyxi"
git branch -m master main
```

**远程仓库**:
```bash
# 方式 1: SSH (推荐，需要配置 SSH key)
git remote add origin git@github.com:andyxai/agent-development-guide-book.git

# 方式 2: HTTPS (需要 GitHub token)
git remote add origin https://github.com/andyxai/agent-development-guide-book.git
```

**首次推送**:
```bash
git add -A
git commit -m "feat: 初始化 agent-development-guide-book 项目"
git push -u origin main
```

**后续推送**:
```bash
git add -A
git commit -m "release: 发布 v{版本号} PDF 版本"
git push origin main
```

---

## 待办事项

### 首次发布 (v2.6)

- [ ] 等待总编确认"可以对外发布了"
- [ ] 检查 agent-development-advanced-guide/docs/v2.6/pdf/ 有 25 个 PDF
- [ ] 复制 PDF 到 agent-development-guide-book/v2.6/pdf/
- [ ] 创建打包文件 v2.6/agent-guide-v2.6.zip
- [ ] 更新 README.md (添加 v2.6 下载链接)
- [ ] Git 提交并推送
- [ ] 验证 GitHub 仓库下载链接有效

### 后续发布

- [ ] 按版本号创建新目录 (v2.7/, v3.0/, ...)
- [ ] 重复发布流程
- [ ] 更新 README.md 版本历史

---

## 与 agent-development-advanced-guide 的关系

| 项目 | 用途 | 内容 |
|------|------|------|
| **agent-development-advanced-guide** | 开发仓库 | Markdown 草稿、审核报告、开发文档 |
| **agent-development-guide-book** | 发布仓库 | 正式 PDF 版本、下载链接 |

**发布流程**:
```
agent-development-advanced-guide (开发)
    │
    │ 总编确认发布
    │
    ▼
生成 PDF (docs/v{版本号}/pdf/)
    │
    │ 复制
    │
    ▼
agent-development-guide-book (发布)
    │
    │ 推送到 GitHub
    │
    ▼
对外发布 (GitHub Releases)
```

---

## 注意事项

### 必须遵循

✅ **必须**:
- 总编确认后才能发布
- PDF 文件与源文件一致
- README 更新完整
- Git 提交并推送

❌ **禁止**:
- 未经总编确认就发布
- 手动修改 PDF 文件
- 跳过 README 更新
- 只发布部分 PDF

### GitHub 认证

**方式 1: SSH Key (推荐)**
```bash
# 生成 SSH key
ssh-keygen -t ed25519 -C "andyxai@126.com"

# 添加到 GitHub
# https://github.com/settings/keys

# 测试连接
ssh -T git@github.com
```

**方式 2: GitHub Token**
```bash
# 创建 Personal Access Token
# https://github.com/settings/tokens

# 使用 token 推送
git push https://<TOKEN>@github.com/andyxai/agent-development-guide-book.git main
```

---

## 总结

### 项目设置

- ✅ 项目已创建：book/agent-development-guide-book/
- ✅ README.md 已创建 (发布指南)
- ✅ PUBLISH-GUIDE.md 已创建 (发布规范)
- ✅ Git 仓库已初始化
- ⏳ 远程仓库待推送 (需要 GitHub 认证)

### 下一步

1. 配置 GitHub 认证 (SSH key 或 Token)
2. 推送到远程仓库
3. 等待总编发布指令
4. 发布 v2.6 PDF 版本

---

**维护者**: andyxi  
**最后更新**: 2026-03-23  
**状态**: ⏳ 等待 GitHub 认证和总编发布指令
