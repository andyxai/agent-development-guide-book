# 第 13 章：高级 RAG 技术

**版本**: v3.1（完整性修复版）  
**最后更新**: 2026-03-28  
**状态**: ✅ 已更新

---

## 【本章导读】

**学习目标**:
- 掌握混合检索与 RRF 融合的最佳实践
- 理解 Rerank 的必要性和实现方法
- **掌握 Rerank 指令优化技巧** ⭐ 新增
- **掌握 Rerank 模型微调方法** ⭐ 新增
- 了解 2024-2026 年高级 RAG 技术演进

**核心知识点**:
- Graph RAG（知识图谱增强检索）
- 混合检索与 RRF 融合
- Rerank 策略与 Cross-Encoder
- **Rerank 指令优化**（明确标准、Few-shot、分步排序） ⭐ 新增
- **Rerank 微调方法**（数据准备、训练、评估） ⭐ 新增
- HyDE、Agentic RAG 等高级技术

---

## 13.1 Graph RAG（知识图谱增强检索）

（... 原有内容保持不变 ...）

---

## 13.2 混合检索与 Rerank

（... 原有内容保持不变 ...）

---

## 13.3 Rerank 策略 ⭐ 更新

### 13.3.1 为什么需要 Rerank？

（... 原有内容保持不变 ...）

### 13.3.2 Rerank 指令优化 ⭐ 新增

**实战经验**: 2026 Q1（用户 CB7D）

#### 1. 明确排序标准

**错误示例**:
```python
prompt = "请对以下文档进行排序"
# 问题：标准不明确，模型不知道按什么排序
```

**正确示例**:
```python
prompt = """请根据相关性对以下文档进行排序。

相关性标准：
1. 文档是否直接回答问题
2. 文档是否包含关键术语
3. 文档的时效性（优先选择最新）

查询：如何优化 RAG 检索速度？

文档列表：
[1] RAG 检索加速方法包括批处理、量化、缓存等
[2] RAG 是一种检索增强生成技术
[3] 向量数据库选型指南

请按相关性从高到低排序，输出文档编号列表。
"""
```

#### 2. Few-shot 示例

```python
prompt = """请根据相关性对以下文档进行排序。

示例 1:
查询：如何优化 Python 代码性能？
文档：
[1] Python 性能优化技巧：批处理、缓存、C 扩展
[2] Python 简介和历史
[3] Python 安装指南
正确排序：[1, 3, 2]

示例 2:
查询：如何选择机器学习模型？
文档：
[1] 机器学习模型选择指南
[2] 深度学习入门教程
[3] 机器学习历史发展
正确排序：[1, 2, 3]

现在请排序：
查询：如何优化 RAG 检索速度？
文档：
[1] RAG 检索加速方法包括批处理、量化、缓存等
[2] RAG 是一种检索增强生成技术
[3] 向量数据库选型指南
"""
```

#### 3. 分步排序策略

```python
# 第一步：粗排（Top 100 → Top 20）
# 使用轻量级 Rerank 模型或规则
def rough_ranking(query, documents):
    """粗排：快速筛选"""
    # 基于关键词匹配、BM25 等
    pass

# 第二步：精排（Top 20 → Top 10）
# 使用 Cross-Encoder 模型
def fine_ranking(query, documents, model):
    """精排：Cross-Encoder 模型"""
    # 使用 Rerank 模型
    pass

# 使用示例
top_100 = retrieve(query)  # 检索 Top 100
top_20 = rough_ranking(query, top_100)  # 粗排 Top 20
top_10 = fine_ranking(query, top_20, rerank_model)  # 精排 Top 10
```

**性能提升**:
- 粗排：10-20ms（快速筛选）
- 精排：100-200ms（准确排序）
- 总体：比直接精排快 5-10 倍

### 13.3.3 Rerank 模型微调 ⭐ 新增

**实战经验**: 2026 Q1（用户 CB7D）

#### 1. 数据准备

```python
from typing import List
import json

# 排序数据格式：(query, documents, ranking)
train_data = [
    {
        "query": "如何优化 RAG 检索速度？",
        "documents": [
            "RAG 检索加速方法包括批处理、量化、缓存等",
            "RAG 是一种检索增强生成技术，用于提升 LLM 准确性",
            "向量数据库选型指南：Chroma vs Pinecone"
        ],
        "ranking": [0, 2, 1]  # 正确排序索引
    },
    {
        "query": "Embedding 模型怎么选？",
        "documents": [
            "选择 Embedding 模型需考虑维度、速度、准确性",
            "LLM 模型选择需要考虑参数量和上下文窗口",
            "Embedding 模型对比：BGE vs M3E"
        ],
        "ranking": [0, 2, 1]
    },
    # ... 更多数据
]

# 加载数据
def load_train_data(file_path: str) -> List[dict]:
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

# 数据增强
def augment_data(data: List[dict]) -> List[dict]:
    """
    数据增强方法：
    1. 随机打乱文档顺序
    2. 同义词替换
    3. 回译（中英互译）
    """
    augmented = []
    for item in data:
        # 原始样本
        augmented.append(item)
        
        # 打乱顺序的样本
        import random
        indices = list(range(len(item["documents"])))
        random.shuffle(indices)
        augmented.append({
            "query": item["query"],
            "documents": [item["documents"][i] for i in indices],
            "ranking": indices  # 新的排序
        })
    
    return augmented
```

#### 2. 模型加载

```python
from transformers import AutoModelForSequenceClassification, AutoTokenizer
import torch

# 加载 Rerank 模型
model_name = "Qwen/Qwen-Rerank-7B"
tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
model = AutoModelForSequenceClassification.from_pretrained(
    model_name,
    num_labels=1,  # 回归任务
    trust_remote_code=True
)

# 移动到 GPU
if torch.cuda.is_available():
    model = model.cuda()

print(f"模型参数：{sum(p.numel() for p in model.parameters()):,}")
```

#### 3. 训练代码

```python
from torch.utils.data import DataLoader, Dataset
from transformers import AdamW, get_cosine_schedule_with_warmup
from tqdm import tqdm
import torch.nn as nn

class RerankDataset(Dataset):
    def __init__(self, data, tokenizer, max_length=512):
        self.data = data
        self.tokenizer = tokenizer
        self.max_length = max_length
    
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        item = self.data[idx]
        
        # 编码 query
        query_encoding = self.tokenizer(
            item["query"],
            max_length=self.max_length,
            padding="max_length",
            truncation=True,
            return_tensors="pt"
        )
        
        # 编码所有文档
        doc_encodings = []
        for doc in item["documents"]:
            doc_encoding = self.tokenizer(
                doc,
                max_length=self.max_length,
                padding="max_length",
                truncation=True,
                return_tensors="pt"
            )
            doc_encodings.append(doc_encoding)
        
        return {
            "query_input_ids": query_encoding["input_ids"].squeeze(0),
            "query_attention_mask": query_encoding["attention_mask"].squeeze(0),
            "doc_input_ids": torch.stack([d["input_ids"].squeeze(0) for d in doc_encodings]),
            "doc_attention_mask": torch.stack([d["attention_mask"].squeeze(0) for d in doc_encodings]),
            "ranking": torch.tensor(item["ranking"], dtype=torch.long)
        }

def train_rerank_model(
    model,
    tokenizer,
    train_data,
    val_data,
    epochs=3,
    batch_size=16,
    learning_rate=2e-5
):
    """训练 Rerank 模型"""
    # 准备数据集
    train_dataset = RerankDataset(train_data, tokenizer)
    val_dataset = RerankDataset(val_data, tokenizer)
    
    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    val_loader = DataLoader(val_dataset, batch_size=batch_size)
    
    # 损失函数（ListNet Loss）
    criterion = nn.CrossEntropyLoss()
    
    # 优化器
    optimizer = AdamW(model.parameters(), lr=learning_rate)
    
    # 学习率调度器
    total_steps = len(train_loader) * epochs
    scheduler = get_cosine_schedule_with_warmup(
        optimizer,
        num_warmup_steps=total_steps * 0.1,
        num_training_steps=total_steps
    )
    
    # 训练循环
    best_val_loss = float('inf')
    
    for epoch in range(epochs):
        print(f"\nEpoch {epoch+1}/{epochs}")
        
        # 训练
        model.train()
        total_train_loss = 0
        
        for batch in tqdm(train_loader, desc="Training"):
            # 获取分数
            query_ids = batch["query_input_ids"]
            query_mask = batch["query_attention_mask"]
            doc_ids = batch["doc_input_ids"]
            doc_mask = batch["doc_attention_mask"]
            rankings = batch["ranking"]
            
            # 计算每个文档的分数
            scores = []
            for i in range(doc_ids.shape[1]):
                inputs = tokenizer(
                    batch["query_input_ids"],
                    doc_ids[:, i, :],
                    return_tensors="pt",
                    padding=True,
                    truncation=True
                )
                outputs = model(**inputs)
                scores.append(outputs.logits)
            
            scores = torch.cat(scores, dim=1)  # [batch_size, num_docs]
            
            # 计算损失
            loss = criterion(scores, rankings)
            
            # 反向传播
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            scheduler.step()
            
            total_train_loss += loss.item()
        
        avg_train_loss = total_train_loss / len(train_loader)
        print(f"训练损失：{avg_train_loss:.4f}")
        
        # 验证
        model.eval()
        total_val_loss = 0
        
        with torch.no_grad():
            for batch in val_loader:
                # 类似训练的计算
                pass
        
        avg_val_loss = total_val_loss / len(val_loader)
        print(f"验证损失：{avg_val_loss:.4f}")
        
        # 保存最佳模型
        if avg_val_loss < best_val_loss:
            best_val_loss = avg_val_loss
            model.save_pretrained("./qwen-rerank-finetuned")
            tokenizer.save_pretrained("./qwen-rerank-finetuned")
            print("✓ 保存最佳模型")
    
    return model
```

#### 4. 评估指标

```python
def evaluate_rerank_model(model, tokenizer, test_data, k=10):
    """
    评估 Rerank 模型
    
    指标：
    - NDCG@k
    - MRR
    - Recall@k
    """
    from sklearn.metrics import ndcg_score
    
    model.eval()
    
    ndcg_scores = []
    mrr_scores = []
    recall_scores = []
    
    with torch.no_grad():
        for item in tqdm(test_data, desc="Evaluating"):
            query = item["query"]
            documents = item["documents"]
            true_ranking = item["ranking"]
            
            # 预测排序
            scores = []
            for doc in documents:
                inputs = tokenizer(query, doc, return_tensors="pt")
                outputs = model(**inputs)
                scores.append(outputs.logits.item())
            
            # 排序
            predicted_ranking = sorted(range(len(scores)), key=lambda i: scores[i], reverse=True)
            
            # NDCG@k
            relevance = [1.0 / (i + 1) for i in true_ranking]
            ndcg = ndcg_score([relevance], [scores], k=k)
            ndcg_scores.append(ndcg)
            
            # MRR
            rank = predicted_ranking.index(true_ranking[0]) + 1
            mrr = 1.0 / rank
            mrr_scores.append(mrr)
            
            # Recall@k
            recall = 1.0 if rank <= k else 0.0
            recall_scores.append(recall)
    
    return {
        "NDCG@{}".format(k): sum(ndcg_scores) / len(ndcg_scores),
        "MRR": sum(mrr_scores) / len(mrr_scores),
        "Recall@{}".format(k): sum(recall_scores) / len(recall_scores)
    }
```

#### 5. 性能提升预期

| 指标 | 预训练模型 | 微调后 | 提升 |
|------|-----------|--------|------|
| **NDCG@10** | 0.70 | 0.80-0.85 | +14-21% |
| **MRR** | 0.65 | 0.75-0.80 | +15-23% |
| **Recall@10** | 0.75 | 0.85-0.90 | +13-20% |

### 13.3.4 关键超参数

| 参数 | 推荐值 | 说明 |
|------|--------|------|
| **batch_size** | 16-32 | Rerank 模型显存占用高 |
| **learning_rate** | 1e-5 ~ 3e-5 | 微调学习率 |
| **epochs** | 3-5 | 太多容易过拟合 |
| **max_length** | 256-512 | query+document 总长度 |
| **num_docs** | 5-10 | 每次排序的文档数 |

### 13.3.5 实战建议

**数据准备**:
- 至少 500 个排序样本
- 每个样本 5-10 个文档
- 覆盖常见查询类型

**训练技巧**:
- 使用 ListNet Loss 或 LambdaRank Loss
- 监控 NDCG@10 指标
- 保存最佳模型 checkpoint

**评估方法**:
- 使用 held-out 测试集
- 报告 NDCG@10、MRR、Recall@10
- 与预训练模型对比提升

---

## 13.4 2024-2026 高级 RAG 技术

（... 原有内容保持不变 ...）

---

## 本章小结

**核心知识点**:
- Graph RAG（知识图谱增强检索）
- 混合检索与 RRF 融合（k=60）
- Rerank 策略与 Cross-Encoder
- **Rerank 指令优化**（明确标准、Few-shot、分步排序） ⭐ 新增
- **Rerank 微调方法**（数据准备、训练、评估） ⭐ 新增
- 高级检索技术（HyDE、Agentic RAG、RAG-Fusion）

**实战技能**:
- 能够设计混合检索策略
- 能够实现 Rerank 重排序
- **能够优化 Rerank 指令（提升 10-15%）** ⭐ 新增
- **能够微调 Rerank 模型（NDCG 提升 14-21%）** ⭐ 新增
- 能够应用高级 RAG 技术

---

## 涉及面试题

1. **为什么需要 Rerank？**
   - 答案：检索模型和生成模型目标不一致，需要精排

2. **Rerank 指令如何优化？** ⭐ 新增
   - 答案：明确标准、Few-shot 示例、分步排序

3. **如何微调 Rerank 模型？** ⭐ 新增
   - 答案：排序数据准备、ListNet Loss、评估指标

---

**知识来源**:
1. Qwen Rerank 官方文档
2. 用户 CB7D 实战经验（2026 Q1）
3. Learning to Rank 经典论文
4. Cross-Encoder 论文

---

**修改记录**:
- v2.1 (2026-03-28): 新增 Rerank 指令优化和微调完整指南
- v2.0 (2026-03-23): 润色版
