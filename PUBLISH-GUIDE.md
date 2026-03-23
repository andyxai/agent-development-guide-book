# PDF 发布流程规范

**版本**: v1.0  
**创建时间**: 2026-03-23  
**适用范围**: agent-development-guide-book 项目

---

## 一、发布流程

### 1.1 触发条件

**总编指令**: "可以对外发布了"

**前置条件**:
- [ ] agent-development-advanced-guide 项目 docs/v{版本号}/pdf/ 目录已生成全部 PDF
- [ ] 所有 PDF 质量检查通过
- [ ] Git 已提交并推送

### 1.2 发布步骤

```
总编确认"可以对外发布了"
    │
    ▼
1. 从 agent-development-advanced-guide 项目复制 PDF
    │
    ├── 来源：book/agent-development-advanced-guide/docs/v{版本号}/pdf/
    └── 目标：book/agent-development-guide-book/v{版本号}/pdf/
    │
    ▼
2. 创建打包下载文件
    │
    └── v{版本号}/agent-guide-v{版本号}.zip
    │
    ▼
3. 更新 README.md
    │
    ├── 更新最新版本号
    ├── 添加下载链接
    └── 更新版本历史
    │
    ▼
4. Git 提交并推送
    │
    ├── git add -A
    ├── git commit -m "release: 发布 v{版本号} PDF 版本"
    └── git push origin main
    │
    ▼
5. 发布完成
```

---

## 二、目录结构

### 2.1 标准结构

```
agent-development-guide-book/
├── README.md                    # 本文件 (发布指南)
├── v2.6/                        # v2.6 版本
│   ├── pdf/                     # PDF 文件 (25 章)
│   │   ├── 01-Agent 概念与架构模式.pdf
│   │   ├── 02-核心组件解析.pdf
│   │   └── ...
│   └── agent-guide-v2.6.zip     # 打包下载
├── v2.5/                        # v2.5 版本
└── ...
```

### 2.2 文件命名

**PDF 文件**:
```
{章节编号}-{中文章节名}.pdf
```

**打包文件**:
```
agent-guide-v{版本号}.zip
```

---

## 三、自动化脚本

### 3.1 PDF 发布脚本

**文件**: `scripts/release-pdf.sh`

```bash
#!/bin/bash

# PDF 发布脚本
# 用法：./release-pdf.sh {版本号}

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "❌ 错误：请提供版本号"
  echo "用法：./release-pdf.sh v2.6"
  exit 1
fi

echo "🚀 开始发布 v$VERSION PDF 版本..."

# 检查源目录
SOURCE_DIR="../agent-development-advanced-guide/docs/$VERSION/pdf"
if [ ! -d "$SOURCE_DIR" ]; then
  echo "❌ 错误：源目录不存在 $SOURCE_DIR"
  exit 1
fi

# 创建目标目录
TARGET_DIR="./$VERSION"
mkdir -p "$TARGET_DIR/pdf"

# 复制 PDF 文件
echo "📄 复制 PDF 文件..."
cp "$SOURCE_DIR"/*.pdf "$TARGET_DIR/pdf/"

# 统计文件数量
pdf_count=$(ls -1 "$TARGET_DIR/pdf"/*.pdf 2>/dev/null | wc -l)
echo "📊 复制了 $pdf_count 个 PDF 文件"

# 创建打包文件
echo "📦 创建打包文件..."
cd "$TARGET_DIR"
zip -r "agent-guide-$VERSION.zip" pdf/
cd - > /dev/null

# 更新 README.md
echo "📝 更新 README.md..."
# (手动更新 README.md 中的版本号、下载链接、版本历史)

echo "✅ v$VERSION PDF 版本发布完成！"
echo ""
echo "下一步:"
echo "1. 更新 README.md 中的版本信息"
echo "2. git add -A"
echo "3. git commit -m \"release: 发布 v$VERSION PDF 版本\""
echo "4. git push origin main"
```

**使用方法**:
```bash
chmod +x scripts/release-pdf.sh
./scripts/release-pdf.sh v2.6
```

---

## 四、README 更新指南

### 4.1 更新最新版本号

**修改位置**: README.md 顶部

**修改前**:
```markdown
**最新版本**: v2.5
```

**修改后**:
```markdown
**最新版本**: v2.6
```

### 4.2 添加下载链接

**修改位置**: README.md "下载最新版本" 部分

**添加内容**:
```markdown
### v2.6 (当前最新版本)

**发布时间**: 2026-03-23  
**状态**: ✅ 已发布  
**章节**: 25 章完整版

**下载链接**:
- [📥 打包下载](v2.6/agent-guide-v2.6.zip) (推荐)
- [📄 单章下载](v2.6/) (选择需要的章节)
```

### 4.3 更新版本历史

**修改位置**: README.md "版本历史" 表格

**添加行**:
```markdown
| **v2.6** | 2026-03-23 | 25 章 | P0/P1/P2问题全修正、目录整理完成 | [下载](#v26-当前最新版本) |
```

---

## 五、Git 提交规范

### 5.1 提交信息格式

```
release: 发布 v{版本号} PDF 版本

## 发布内容
- PDF 章节数：{X} 章
- 打包文件：agent-guide-v{版本号}.zip
- 发布时间：{日期}

## 更新内容
- 复制 PDF 文件到 v{版本号}/pdf/
- 创建打包下载文件
- 更新 README.md
```

### 5.2 提交示例

```bash
git add -A
git commit -m "release: 发布 v2.6 PDF 版本

## 发布内容
- PDF 章节数：25 章
- 打包文件：agent-guide-v2.6.zip
- 发布时间：2026-03-23

## 更新内容
- 复制 PDF 文件到 v2.6/pdf/
- 创建打包下载文件
- 更新 README.md"
git push origin main
```

---

## 六、检查清单

### 6.1 发布前检查

- [ ] 总编已确认"可以对外发布了"
- [ ] agent-development-advanced-guide 项目 PDF 已生成
- [ ] PDF 质量检查通过 (数量、格式、内容)
- [ ] Git 已提交并推送

### 6.2 发布后检查

- [ ] PDF 文件已复制到 v{版本号}/pdf/
- [ ] 打包文件已创建
- [ ] README.md 已更新
- [ ] Git 已提交并推送
- [ ] 下载链接有效
- [ ] 版本号正确

---

## 七、注意事项

### 7.1 必须遵循

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

### 7.2 常见问题

**Q: PDF 文件数量不对？**

A: 检查源目录 PDF 数量：
```bash
ls -1 ../agent-development-advanced-guide/docs/v{版本号}/pdf/*.pdf | wc -l
```

**Q: 打包文件太大？**

A: 压缩 PDF 文件：
```bash
# 使用 ghostscript 压缩
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
   -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET \
   -dBATCH -sOutputFile=output.pdf input.pdf
```

**Q: README 更新后格式错误？**

A: 检查 Markdown 语法，使用在线预览工具验证。

---

## 八、总结

### 8.1 核心规则

1. **总编确认原则**: 必须总编确认后才能发布
2. **完整复制原则**: 全部 PDF 复制，不单独复制
3. **README 更新原则**: 发布后必须更新 README
4. **Git 管理原则**: 纳入 Git 版本控制

### 8.2 检查清单

**发布前**:
- [ ] 总编已确认
- [ ] PDF 已生成
- [ ] 质量检查通过

**发布后**:
- [ ] PDF 已复制
- [ ] 打包文件已创建
- [ ] README 已更新
- [ ] Git 已推送

---

**维护者**: andyxi  
**最后更新**: 2026-03-23  
**状态**: ✅ 必须遵循  
**版本**: v1.0
