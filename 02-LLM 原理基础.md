# 第 2 章：LLM 原理基础

**版本**: v3.1（深度增强版）  
**最后更新**: 2026-03-27  
**状态**: ✅ 已完成

---

## 【本章导读】

**学习目标**:
- 理解 LLM 的工作原理（Token 化、Attention 机制、生成过程）
- 掌握 Token 计算方法，能够准确估算成本
- 理解温度、Top-K、Top-P 等参数对生成的影响
- 为后续性能优化章节打下理论基础

**核心知识点**:
- Token 化原理与计算示例
- Transformer 架构简介
- Attention 机制详解（Q/K/V）
- 文本生成过程（自回归）
- 采样策略（温度、Top-K、Top-P）

**与后续章节的关联**:
- 第 17 章性能优化：基于 Token 化原理的优化技术
- 第 18 章 API 与成本：基于 Token 计算的成本估算
- 第 20 章模型微调：基于 Transformer 架构的微调方法

---

## 2.1 Token 化原理

### 2.1.1 什么是 Token？

**Token** 是 LLM 处理文本的基本单位，既不是字符也不是单词，而是介于两者之间的文本片段。

**Token 化示例**:

```
英文示例:
输入："Hello world!"
Token 化：["Hello", " world", "!"]
Token 数：3 个

中文示例:
输入："你好世界"
Token 化：["你", "好", "世", "界"]
Token 数：4 个
```

**Token 与字符的关系**:
- **英文**: 1 个 Token ≈ 4 个字符 ≈ 0.75 个单词
- **中文**: 1 个 Token ≈ 1.5 个汉字
- **代码**: 1 个 Token ≈ 2-3 个字符（因编程语言而异）

### 2.1.2 Token 化方法

**主流 Token 化算法**:

| 算法 | 提出者 | 特点 | 使用模型 |
|------|--------|------|---------|
| **BPE** (Byte Pair Encoding) | OpenAI | 基于频率合并字符对 | GPT 系列 |
| **WordPiece** | Google | 基于子词单元 | BERT、早期 Transformer |
| **SentencePiece** | Google | 无监督、语言无关 | T5、LLaMA |
| **tiktoken** | OpenAI | 基于 BPE 的优化版本 | GPT-4、GPT-4o |

**BPE 算法原理**（简化版）:

```
初始词表：["a", "b", "c", "d", "...", "z"]

训练过程:
1. 统计所有字符对的频率
2. 合并频率最高的字符对（如"th"）
3. 将"th"加入词表
4. 重复步骤 1-3，直到词表达到目标大小

最终词表：["a", "b", ..., "th", "ing", "tion", ...]
```

**实际 Token 化示例**（使用 tiktoken）:

```python
import tiktoken

# 加载 GPT-4 的 Token 化器
encoder = tiktoken.encoding_for_model("gpt-4")

# Token 化
text = "Spec-Driven Development is a methodology."
tokens = encoder.encode(text)

print(f"原文：{text}")
print(f"Token 数：{len(tokens)}")
print(f"Token IDs: {tokens}")

# 输出:
# 原文：Spec-Driven Development is a methodology.
# Token 数：8
# Token IDs: [1234, 5678, 9012, 345, 67, 8901, 2345, 12]
```

### 2.1.3 Token 计算实战

**为什么需要准确计算 Token？**
- **成本估算**: LLM API 按 Token 计费
- **性能优化**: Token 数影响推理速度
- **上下文管理**: 避免超出上下文窗口限制

**Token 计算工具**:

| 工具 | 适用模型 | 链接 |
|------|---------|------|
| **OpenAI Tokenizer** | GPT-3.5/GPT-4 | https://platform.openai.com/tokenizer |
| **tiktoken** | GPT 系列 | Python 库 |
| **Anthropic Token Calculator** | Claude 系列 | https://docs.anthropic.com/claude/docs/token-counting |
| **LLM Token Counter** | 多模型 | VS Code 插件 |

**Token 计算示例**:

```python
# 使用 tiktoken 计算 Token 数
import tiktoken

def count_tokens(text, model="gpt-4"):
    """计算文本的 Token 数"""
    encoder = tiktoken.encoding_for_model(model)
    tokens = encoder.encode(text)
    return len(tokens)

# 示例
text = """
# 需求文档：用户登录功能

## 背景
用户需要通过邮箱和密码登录系统

## 验收条件
- WHEN 用户输入正确的邮箱和密码 THEN 系统应该成功登录
- WHEN 用户输入错误的密码 THEN 系统应该返回错误提示
"""

token_count = count_tokens(text)
print(f"Token 数：{token_count}")
# 输出：Token 数：约 80-100（取决于具体文本）
```

**Token 估算经验法则**:

| 内容类型 | Token 估算 |
|---------|-----------|
| **英文文本** | 1000 词 ≈ 1300 Token |
| **中文文本** | 1000 字 ≈ 600-700 Token |
| **代码** | 100 行 ≈ 300-500 Token |
| **JSON** | 1KB ≈ 250-300 Token |
| **Markdown** | 1KB ≈ 200-250 Token |

---

## 2.2 Transformer 架构简介

### 2.2.1 Transformer 核心组件

Transformer 是 LLM 的基础架构，由 Encoder（编码器）和 Decoder（解码器）组成。

**架构图**（简化版）:

```
输入文本 → Token 化 → 嵌入层 → Encoder 层 → Decoder 层 → 输出概率 → 采样 → 输出文本
                                    ↓              ↓
                              Self-Attention   Self-Attention
                              + Feed Forward   + Cross-Attention
                                               + Feed Forward
```

**核心组件**:

| 组件 | 作用 | 输出维度 |
|------|------|---------|
| **嵌入层** (Embedding) | 将 Token 转换为向量 | [batch_size, seq_len, d_model] |
| **Self-Attention** | 捕捉序列内依赖关系 | [batch_size, seq_len, d_model] |
| **Feed Forward** | 非线性变换 | [batch_size, seq_len, d_model] |
| **Layer Norm** | 层归一化，稳定训练 | [batch_size, seq_len, d_model] |

### 2.2.2 Self-Attention 机制详解

**Attention 的核心思想**: 让模型在处理每个 Token 时，能够"关注"序列中的其他相关 Token。

**Q/K/V 概念**:

- **Q (Query)**: 查询向量，表示"我想找什么"
- **K (Key)**: 键向量，表示"我有什么"
- **V (Value)**: 值向量，表示"实际内容"

**Attention 计算过程**:

```
1. 计算 Q、K、V 矩阵
   Q = X × W_Q
   K = X × W_K
   V = X × W_V

2. 计算注意力分数
   Attention(Q, K, V) = softmax(Q × K^T / √d_k) × V

3. 输出加权后的 V
   Output = Attention(Q, K, V)
```

**直观理解**:

```
句子："The animal didn't cross the street because it was too tired."

当处理"it"时，Attention 机制会：
- 计算"it"与所有词的注意力分数
- 发现"animal"的分数最高（因为"it"指代"animal"）
- 加权聚合"animal"的信息到"it"的表示中

结果：模型理解"it"指代"animal"，而不是"street"
```

### 2.2.3 Multi-Head Attention

**为什么需要 Multi-Head？**

单个 Attention 头只能捕捉一种依赖关系，Multi-Head 允许模型同时关注不同位置的不同信息。

**Multi-Head 结构**:

```
输入 → [Head 1] ─┐
     → [Head 2] ─┤
     → [Head 3] ─┼→ 拼接 → 线性变换 → 输出
     → [Head 4] ─┤
     → ...      ─┘
```

**Multi-Head 的优势**:
- **Head 1**: 可能关注语法关系（主谓宾）
- **Head 2**: 可能关注指代关系（代词指代）
- **Head 3**: 可能关注语义关系（同义词）
- **Head 4**: 可能关注长距离依赖

---

## 2.3 文本生成过程

### 2.3.1 自回归生成

LLM 采用**自回归**（Autoregressive）方式生成文本：每次生成一个 Token，然后将生成的 Token 作为输入的一部分，继续生成下一个 Token。

**生成过程**:

```
Step 1:
输入："Hello"
输出：" world" (概率最高)

Step 2:
输入："Hello world"
输出："!" (概率最高)

Step 3:
输入："Hello world!"
输出："<EOS>" (结束标记)
```

**自回归的优缺点**:

| 优点 | 缺点 |
|------|------|
| 生成质量高 | 生成速度慢（串行） |
| 上下文连贯 | 无法并行生成 |
| 支持长文本 | Token 越多，延迟越高 |

### 2.3.2 采样策略

LLM 生成 Token 时，需要从概率分布中采样。不同的采样策略会影响生成结果的多样性和质量。

**温度**（Temperature）:

```
温度 = 0.0: 贪婪采样，总是选择概率最高的 Token（确定性最高）
温度 = 0.7: 平衡多样性和质量（推荐）
温度 = 1.0: 标准采样，按原始概率分布
温度 = 2.0: 高多样性，可能生成不合理内容
```

**温度对概率分布的影响**:

```
原始概率：[0.5, 0.3, 0.1, 0.1]

温度 = 0.5: [0.73, 0.20, 0.04, 0.03]  (更集中)
温度 = 1.0: [0.50, 0.30, 0.10, 0.10]  (不变)
温度 = 2.0: [0.35, 0.28, 0.18, 0.18]  (更分散)
```

**Top-K 采样**:

```
Top-K = 1: 只从概率最高的 1 个 Token 中选择（贪婪）
Top-K = 10: 从概率最高的 10 个 Token 中选择
Top-K = 50: 从概率最高的 50 个 Token 中选择（推荐）
Top-K = ∞: 从所有 Token 中选择（无限制）
```

**Top-P **(Nucleus):

```
Top-P = 0.1: 只从累积概率前 10% 的 Token 中选择
Top-P = 0.9: 从累积概率前 90% 的 Token 中选择（推荐）
Top-P = 1.0: 从所有 Token 中选择（无限制）
```

**推荐配置**:

| 场景 | Temperature | Top-K | Top-P |
|------|------------|-------|-------|
| **代码生成** | 0.1-0.3 | 10-20 | 0.8-0.9 |
| **技术文档** | 0.3-0.5 | 20-40 | 0.85-0.95 |
| **创意写作** | 0.7-0.9 | 40-60 | 0.9-0.95 |
| **头脑风暴** | 0.9-1.2 | 50-100 | 0.95-1.0 |

---

## 2.4 上下文窗口与注意力衰减

### 2.4.1 上下文窗口限制

**主流模型的上下文窗口**:

| 模型 | 上下文窗口 | 约等于 |
|------|-----------|--------|
| **GPT-3.5** | 4K-16K Token | 3K-12K 汉字 |
| **GPT-4** | 8K-128K Token | 6K-96K 汉字 |
| **Claude-3** | 200K Token | 150K 汉字 |
| **Gemini 1.5** | 1M Token | 750K 汉字 |

**上下文窗口的影响**:
- **成本**: Token 越多，成本越高
- **延迟**: Token 越多，推理越慢
- **注意力**: Token 越多，注意力越分散

### 2.4.2 注意力衰减

**现象**: LLM 对早期内容的注意力会随距离衰减，导致"忘记"早期信息。

**实验数据**（"大海捞针"测试）:

| 上下文长度 | 开头信息召回率 | 中间信息召回率 | 结尾信息召回率 |
|-----------|--------------|--------------|--------------|
| **8K** | 95% | 85% | 95% |
| **32K** | 90% | 70% | 95% |
| **128K** | 85% | 60% | 95% |

**结论**:
- 开头和结尾的信息 recall 率高（首因效应、近因效应）
- 中间的信息 recall 率低（容易"迷失"在长上下文中）
- 上下文越长，中间信息 recall 率越低

**应对策略**:
1. **重要信息放开头或结尾**: 关键设定、约束条件放在 Prompt 开头或结尾
2. **重复关键信息**: 在长对话中定期重复核心设定
3. **使用 RAG**: 检索相关片段，而不是依赖长上下文
4. **摘要压缩**: 将早期内容压缩为摘要，减少 Token 数

---

## 2.5 LLM 的局限性与幻觉

### 2.5.1 幻觉的根源

**幻觉**（Hallucination）: LLM 生成看似合理但实际错误或无依据的内容。

**幻觉的四大根源**:

| 根源 | 原理 | 缓解策略 |
|------|------|---------|
| **训练数据噪声** | 模型学习了错误信息 | RAG 增强、事实核查 |
| **概率生成本质** | 预测最可能的 Token，不是最准确的 | 降低 temperature、约束输出 |
| **上下文窗口限制** | 无法记住所有信息 | 记忆管理、关键信息重复 |
| **指令理解偏差** | 模型误解任务要求 | 清晰 Prompt、Few-shot 示例 |

### 2.5.2 幻觉检测与缓解

**检测方法**:
- **事实核查**: 与检索结果对比
- **自洽性检查**: 多次生成对比
- **引用验证**: 检查是否有依据
- **NLI 模型**: 判断生成内容与事实是否矛盾

**缓解策略**:
- **降低 temperature**: 0.3-0.5（减少随机性）
- **使用 RAG**: 检索相关知识，注入上下文
- **添加约束**: "如果不知道，请说不知道，不要编造"
- **多轮验证**: 生成→验证→修复循环

---

## 本章小结

**核心知识点**:
- **Token 化**: LLM 处理文本的基本单位，1 Token ≈ 4 英文字符 ≈ 1.5 汉字
- **Transformer**: 基于 Self-Attention 的架构，Q/K/V 机制捕捉依赖关系
- **自回归生成**: 每次生成一个 Token，串行过程导致延迟
- **采样策略**: Temperature、Top-K、Top-P 控制生成多样性和质量
- **上下文窗口**: 有限制，注意力会衰减，重要信息放开头或结尾
- **幻觉根源**: 训练数据噪声、概率生成本质、上下文限制、指令理解偏差

**与后续章节的关联**:
- 第 17 章：基于 Token 化原理的 Prompt 压缩技术
- 第 18 章：基于 Token 计算的成本估算
- 第 20 章：基于 Transformer 架构的模型微调

---

## 知识来源

1. **Transformer 论文**: "Attention Is All You Need", Vaswani et al., NeurIPS 2017
2. **BPE 算法**: "Neural Machine Translation of Rare Words with Subword Units", Sennrich et al., ACL 2016
3. **tiktoken 文档**: https://github.com/openai/tiktoken
4. **OpenAI Tokenizer**: https://platform.openai.com/tokenizer
5. **大海捞针测试**: "Lost in the Middle: How Language Models Use Long Contexts", Liu et al., 2023

---

**修改记录**:
- v3.1 (2026-03-27): 深度增强版 - 补充 Token 计算示例、Attention 机制详解、采样策略对比
- v3.0 (2026-03-26): 学习路径重组版 - 从原 23 章移到第 2 章
- v2.0 (2026-03-23): 润色版 - 句子简化、删除重复
