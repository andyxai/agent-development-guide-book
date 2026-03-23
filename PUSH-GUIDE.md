# agent-development-guide-book 推送指南

**创建时间**: 2026-03-23  
**状态**: ⏳ 等待手动推送

---

## 当前状态

### 本地仓库

- ✅ 项目已创建：`book/agent-development-guide-book/`
- ✅ Git 已初始化
- ✅ 文件已提交 (commit 66e6f25)
- ✅ 远程仓库已配置：`git@github.com:andyxai/agent-development-guide-book.git`
- ❌ SSH 连接失败 (GitHub 服务器拒绝连接)

### 已提交文件

- README.md (发布指南)
- PUBLISH-GUIDE.md (发布流程规范)
- v2.6/pdf/ (空目录，待复制 PDF)

---

## 推送方法

### 方法 1: 手动推送 (推荐)

**步骤**:

1. **打开终端**:
```bash
cd /home/admin/openclaw/workspace/book/agent-development-guide-book
```

2. **检查状态**:
```bash
git status
git log --oneline -3
git remote -v
```

3. **推送到 GitHub**:
```bash
# 方式 A: 使用 SSH (需要 SSH key)
git push origin main

# 方式 B: 使用 HTTPS + Token
git remote set-url origin https://github.com/andyxai/agent-development-guide-book.git
git push origin main
# 会提示输入 GitHub username 和 token
```

4. **验证推送**:
```bash
# 访问 GitHub 仓库查看
https://github.com/andyxai/agent-development-guide-book
```

---

### 方法 2: 使用 GitHub Desktop

**步骤**:

1. 打开 GitHub Desktop
2. File → Add Local Repository → 选择 `agent-development-guide-book` 目录
3. 点击 "Publish repository"
4. 选择 "Keep it private" 或 "Public"
5. 点击 Publish

---

### 方法 3: 使用 VS Code

**步骤**:

1. 在 VS Code 中打开 `agent-development-guide-book` 文件夹
2. 点击左侧 Git 图标
3. 点击 "..." → Push
4. 如果提示认证，输入 GitHub token

---

## GitHub Token 获取

**如果还没有 Token**:

1. 访问：https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 填写 Note: `agent-development-guide-book`
4. 选择 Scopes:
   - ✅ repo (Full control of private repositories)
   - ✅ workflow (Update GitHub Action workflows)
5. 点击 "Generate token"
6. **复制并保存 Token** (只显示一次！)

**使用 Token 推送**:
```bash
git remote set-url origin https://github.com/andyxai/agent-development-guide-book.git
git push origin main
# Username: andyxi
# Password: <粘贴刚才复制的 Token>
```

---

## SSH Key 配置

**如果还没有 SSH Key**:

1. **生成 SSH Key**:
```bash
ssh-keygen -t ed25519 -C "andyxai@126.com"
# 一路回车即可
```

2. **查看公钥**:
```bash
cat ~/.ssh/id_ed25519.pub
# 或
cat ~/.ssh/github_agent_guide.pub
```

3. **添加到 GitHub**:
   - 访问：https://github.com/settings/keys
   - 点击 "New SSH key"
   - Title: `agent-development-guide-book`
   - Key: 粘贴刚才查看的公钥内容
   - 点击 "Add SSH key"

4. **测试连接**:
```bash
ssh -T git@github.com
# 应该显示：Hi andyxi! You've successfully authenticated...
```

---

## 推送后验证

**检查推送成功**:

1. **访问 GitHub 仓库**:
```
https://github.com/andyxai/agent-development-guide-book
```

2. **查看文件**:
- README.md ✅
- PUBLISH-GUIDE.md ✅
- v2.6/ 目录 ✅

3. **检查 commit 历史**:
- 应该有 1 个 commit: "feat: 初始化 agent-development-guide-book 项目"

---

## 后续发布流程

**推送成功后，发布 v2.6 PDF 的步骤**:

1. **等待总编确认**: "可以对外发布了"

2. **复制 PDF**:
```bash
cd /home/admin/openclaw/workspace/book/agent-development-guide-book

# 从源项目复制 PDF
cp ../agent-development-advanced-guide/docs/v2.6/pdf/*.pdf v2.6/pdf/
```

3. **创建打包文件**:
```bash
cd v2.6
zip -r agent-guide-v2.6.zip pdf/
cd -
```

4. **更新 README.md**:
- 更新最新版本号
- 添加下载链接
- 更新版本历史表格

5. **Git 提交并推送**:
```bash
git add -A
git commit -m "release: 发布 v2.6 PDF 版本"
git push origin main
```

---

## 常见问题

### Q: SSH 连接被拒绝？

**A**: 使用 HTTPS + Token 方式推送：
```bash
git remote set-url origin https://github.com/andyxai/agent-development-guide-book.git
git push origin main
# 输入 GitHub username 和 token
```

### Q: Token 无效？

**A**: 检查 Token 权限：
- 必须有 `repo` 权限
- 检查 Token 是否过期
- 重新生成 Token

### Q: 仓库不存在？

**A**: 先在 GitHub 上创建仓库：
1. 访问：https://github.com/new
2. Repository name: `agent-development-guide-book`
3. 选择 Public 或 Private
4. 点击 "Create repository"
5. 然后推送

---

## 联系支持

- **GitHub 文档**: https://docs.github.com/
- **SSH 问题**: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- **Token 问题**: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

---

**维护者**: andyxi  
**最后更新**: 2026-03-23  
**状态**: ⏳ 等待手动推送
