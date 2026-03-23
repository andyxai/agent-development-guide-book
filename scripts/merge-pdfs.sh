#!/bin/bash

# PDF 合并脚本
# 用法：./merge-pdfs.sh {版本号}

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "❌ 错误：请提供版本号"
  echo "用法：./merge-pdfs.sh v2.6"
  exit 1
fi

echo "🚀 开始合并 v$VERSION PDF..."

# 检查 pdf 目录
PDF_DIR="./$VERSION/pdf"
if [ ! -d "$PDF_DIR" ]; then
  echo "❌ 错误：PDF 目录不存在 $PDF_DIR"
  exit 1
fi

# 统计 PDF 数量
pdf_count=$(ls -1 "$PDF_DIR"/*.pdf 2>/dev/null | wc -l)
echo "📊 找到 $pdf_count 个 PDF 文件"

if [ $pdf_count -eq 0 ]; then
  echo "❌ 错误：没有 PDF 文件"
  exit 1
fi

# 创建 complete 目录
COMPLETE_DIR="./$VERSION/complete"
mkdir -p "$COMPLETE_DIR"

# 合并 PDF
echo "📝 合并 PDF..."

# 方法 1: 使用 pdftk (推荐)
if command -v pdftk &> /dev/null; then
  echo "  使用 pdftk 合并..."
  
  # 获取所有 PDF 文件列表
  pdf_files=$(ls -1 "$PDF_DIR"/*.pdf | sort)
  
  # 创建输出文件
  output_file="$COMPLETE_DIR/Agent 开发进阶指南 -$VERSION-完整版.pdf"
  
  # 合并
  pdftk $pdf_files cat output "$output_file"
  
  echo "✅ 使用 pdftk 合并完成！"
  
# 方法 2: 使用 gs (Ghostscript)
elif command -v gs &> /dev/null; then
  echo "  使用 gs (Ghostscript) 合并..."
  
  output_file="$COMPLETE_DIR/Agent 开发进阶指南 -$VERSION-完整版.pdf"
  
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite \
     -sOutputFile="$output_file" \
     $(ls -1 "$PDF_DIR"/*.pdf | sort)
  
  echo "✅ 使用 gs 合并完成！"
  
# 方法 3: 使用 Python pypdf
elif command -v python3 &> /dev/null; then
  echo "  使用 Python pypdf 合并..."
  
  python3 - <<PYTHON
import os
from pypdf import PdfMerger

pdf_dir = "$PDF_DIR"
complete_dir = "$COMPLETE_DIR"
output_file = os.path.join(complete_dir, "Agent 开发进阶指南 -$VERSION-完整版.pdf")

# 获取所有 PDF 文件 (按名称排序)
pdf_files = sorted([f for f in os.listdir(pdf_dir) if f.endswith('.pdf')])

if not pdf_files:
    print("❌ 错误：没有 PDF 文件")
    exit(1)

# 创建合并器
merger = PdfMerger()

# 添加所有 PDF
for pdf_file in pdf_files:
    print(f"  添加：{pdf_file}")
    merger.append(os.path.join(pdf_dir, pdf_file))

# 写入输出文件
merger.write(output_file)
merger.close()

print(f"✅ 合并完成：{output_file}")
PYTHON
  
  echo "✅ 使用 Python pypdf 合并完成！"
  
else
  echo "❌ 错误：未找到 PDF 合并工具"
  echo ""
  echo "请安装以下工具之一:"
  echo "  1. pdftk: sudo apt-get install pdftk"
  echo "  2. gs (Ghostscript): sudo apt-get install ghostscript"
  echo "  3. Python pypdf: pip3 install pypdf"
  exit 1
fi

# 验证输出文件
if [ -f "$COMPLETE_DIR/Agent 开发进阶指南 -$VERSION-完整版.pdf" ]; then
  file_size=$(du -h "$COMPLETE_DIR/Agent 开发进阶指南 -$VERSION-完整版.pdf" | cut -f1)
  echo ""
  echo "✅ v$VERSION PDF 合并完成！"
  echo "  输出文件：$COMPLETE_DIR/Agent 开发进阶指南 -$VERSION-完整版.pdf"
  echo "  文件大小：$file_size"
  echo "  章节数：$pdf_count 章"
else
  echo "❌ 错误：合并失败"
  exit 1
fi
