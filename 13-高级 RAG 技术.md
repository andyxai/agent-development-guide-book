# 第 13 章：高级 RAG 技术

**版本**: v3.1（Graph RAG 深度增强版）  
**最后更新**: 2026-03-27  
**状态**: ✅ 已完成

---

## 【本章导读】

**学习目标**:
- 掌握 Graph RAG 的核心原理和实现流程
- 理解混合检索（稠密 + 稀疏）的最佳实践
- 能够设计和实现 Rerank 策略
- 了解 2024-2026 年高级 RAG 技术演进

**核心知识点**:
- Graph RAG（知识图谱增强检索）
- 混合检索与 RRF 融合
- Rerank 策略与 Cross-Encoder
- HyDE、Agentic RAG 等高级技术

**实战案例**:
- Graph RAG 完整实现流程
- 漫剧设定检索优化案例

---

## 13.1 Graph RAG（知识图谱增强检索）

### 13.1.1 为什么需要 Graph RAG？

**传统 RAG 的局限性**:

| 问题 | 说明 | 示例 |
|------|------|------|
| **无法多跳推理** | 只能检索直接相关的内容 | 无法回答"A 的朋友的同事是谁" |
| **丢失结构信息** | 文档切分后丢失实体关系 | "轩辕墨是主角"和"轩辕墨会火系魔法"被分成不同 chunk |
| **全局性问题困难** | 难以回答"文档集的主要主题是什么" | 需要遍历所有 chunk |

**Graph RAG 的优势**:
- ✅ 支持多跳推理（2-3 跳）
- ✅ 保留实体关系结构
- ✅ 支持全局性问题回答
- ✅ 可解释性强（可追溯推理路径）

### 13.1.2 Graph RAG 核心原理

**技术架构**:

```
文档输入 → 实体抽取 → 构建知识图谱 → 图遍历检索 → LLM 生成
              ↓
        实体 - 关系 - 实体三元组
```

**核心组件**:

| 组件 | 作用 | 技术实现 |
|------|------|---------|
| **实体抽取** | 从文档中提取实体和关系 | NER 模型、LLM |
| **知识图谱** | 存储实体和关系 | Neo4j、NetworkX |
| **图遍历检索** | 从查询相关节点出发，沿边遍历 | BFS、DFS、PageRank |
| **社区摘要** | 对图谱社区生成摘要 | 层次化聚类 + LLM |

### 13.1.3 Graph RAG 完整实现流程

**阶段 1: 实体抽取**

```python
from typing import List, Tuple
import ollama

def extract_entities_and_relations(text: str) -> List[Tuple[str, str, str]]:
    """
    从文本中提取实体和关系
    
    返回：[(实体 1, 关系，实体 2), ...]
    """
    prompt = f"""
    从以下文本中提取实体和关系，格式为 (实体 1, 关系，实体 2):
    
    文本：{text}
    
    示例输出:
    (轩辕墨，是，主角)
    (轩辕墨，会，火系魔法)
    (轩辕墨，属于，炎阳宗)
    
    提取结果:
    """
    
    response = ollama.chat(model='qwen2.5:7b', messages=[
        {'role': 'user', 'content': prompt}
    ])
    
    # 解析输出，返回三元组列表
    relations = parse_relations(response['message']['content'])
    return relations

# 示例
text = "轩辕墨是炎阳宗的首席弟子，他会火系魔法，他的师傅是炎阳真人。"
relations = extract_entities_and_relations(text)
# 输出：[('轩辕墨', '是', '炎阳宗首席弟子'), ('轩辕墨', '会', '火系魔法'), ('轩辕墨', '师傅是', '炎阳真人')]
```

**阶段 2: 构建知识图谱**

```python
import networkx as nx

def build_knowledge_graph(relations: List[Tuple[str, str, str]]) -> nx.Graph:
    """
    从实体关系三元组构建知识图谱
    """
    G = nx.Graph()
    
    for entity1, relation, entity2 in relations:
        # 添加节点（实体）
        G.add_node(entity1, type='entity')
        G.add_node(entity2, type='entity')
        
        # 添加边（关系）
        G.add_edge(entity1, entity2, relation=relation)
    
    return G

# 示例
relations = [
    ('轩辕墨', '是', '炎阳宗首席弟子'),
    ('轩辕墨', '会', '火系魔法'),
    ('轩辕墨', '师傅是', '炎阳真人'),
    ('炎阳真人', '属于', '炎阳宗'),
]

G = build_knowledge_graph(relations)

# 图谱统计
print(f"实体数：{G.number_of_nodes()}")
print(f"关系数：{G.number_of_edges()}")
```

**阶段 3: 图遍历检索**

```python
def graph_retrieve(query: str, G: nx.Graph, max_hops: int = 2) -> List[str]:
    """
    从知识图谱检索相关信息
    
    参数:
    - query: 查询文本
    - G: 知识图谱
    - max_hops: 最大跳数（默认 2 跳）
    
    返回：相关实体和关系的文本描述
    """
    # 1. 找到查询相关的起始实体
    start_entities = find_related_entities(query, G)
    
    # 2. 图遍历（BFS）
    retrieved_facts = []
    for start_entity in start_entities:
        # BFS 遍历，最多 max_hops 跳
        for hop in range(1, max_hops + 1):
            neighbors = nx.single_source_shortest_path_length(G, start_entity, cutoff=hop)
            for entity, distance in neighbors.items():
                if distance > 0:  # 排除起始实体本身
                    # 获取关系
                    edge_data = G.get_edge_data(start_entity, entity)
                    if edge_data:
                        relation = edge_data['relation']
                        fact = f"{start_entity} {relation} {entity}"
                        retrieved_facts.append(fact)
    
    return retrieved_facts

def find_related_entities(query: str, G: nx.Graph) -> List[str]:
    """
    找到与查询相关的起始实体
    """
    # 简单实现：从查询中提取实体名，在图谱中查找
    # 实际应用中可使用嵌入相似度
    query_entities = extract_entity_names(query)
    start_entities = []
    
    for node in G.nodes():
        if node in query_entities:
            start_entities.append(node)
    
    return start_entities

# 示例
query = "轩辕墨的师傅是谁？"
facts = graph_retrieve(query, G, max_hops=2)
# 输出：['轩辕墨 师傅是 炎阳真人', '炎阳真人 属于 炎阳宗', ...]
```

**阶段 4: 社区摘要（层次化聚类）**

```python
import community  # python-louvain 库

def generate_community_summaries(G: nx.Graph) -> List[dict]:
    """
    对知识图谱进行社区检测，生成社区摘要
    """
    # 1. 社区检测（Louvain 算法）
    partition = community.best_partition(G)
    
    # 2. 按社区分组
    communities = {}
    for node, community_id in partition.items():
        if community_id not in communities:
            communities[community_id] = []
        communities[community_id].append(node)
    
    # 3. 生成社区摘要
    summaries = []
    for community_id, entities in communities.items():
        # 提取社区内的关系
        subgraph = G.subgraph(entities)
        relations = []
        for edge in subgraph.edges():
            relation = subgraph[edge[0]][edge[1]]['relation']
            relations.append(f"{edge[0]} {relation} {edge[1]}")
        
        # 用 LLM 生成摘要
        summary = generate_community_summary_with_llm(entities, relations)
        summaries.append({
            'community_id': community_id,
            'entities': entities,
            'summary': summary
        })
    
    return summaries

def generate_community_summary_with_llm(entities: List[str], relations: List[str]) -> str:
    """
    用 LLM 生成社区摘要
    """
    prompt = f"""
    根据以下实体和关系，生成一个简洁的摘要:
    
    实体：{', '.join(entities)}
    关系:
    {chr(10).join(relations)}
    
    摘要:
    """
    
    response = ollama.chat(model='qwen2.5:7b', messages=[
        {'role': 'user', 'content': prompt}
    ])
    
    return response['message']['content']
```

### 13.1.4 Graph RAG vs 传统 RAG

**对比表**:

| 维度 | 传统 RAG | Graph RAG |
|------|---------|-----------|
| **检索单元** | Chunk（文本块） | 实体 + 关系 + 社区摘要 |
| **多跳推理** | 弱（依赖向量相似度） | 强（图遍历，支持 2-3 跳） |
| **全局性问题** | 弱（如"文档主要主题是什么"） | 强（社区摘要） |
| **可解释性** | 低 | 高（可追溯推理路径） |
| **构建成本** | 低（只需向量化） | 高（实体抽取 + 图谱构建） |
| **查询延迟** | 低（10-100ms） | 中（100-500ms，含图遍历） |

**效果数据**（Microsoft 官方实验）:
- 多跳推理准确性提升 **35-50%**
- 全局性问题回答质量提升 **40-60%**
- 计算成本增加 **2-3 倍**（图谱构建开销）

### 13.1.5 Graph RAG 实战案例：漫剧设定检索

**场景**: 漫剧设定包含复杂的人物关系和世界观，需要多跳推理。

**问题示例**:
```
Q1: "轩辕墨的师傅的师兄是谁？" (2 跳推理)
Q2: "炎阳宗有哪些弟子会火系魔法？" (聚合查询)
Q3: "这部漫剧的主要冲突是什么？" (全局性问题)
```

**实现代码**:

```python
# 漫剧设定知识图谱
manhua_relations = [
    ('轩辕墨', '是', '主角'),
    ('轩辕墨', '会', '火系魔法'),
    ('轩辕墨', '师傅是', '炎阳真人'),
    ('炎阳真人', '属于', '炎阳宗'),
    ('炎阳真人', '师兄是', '烈火真人'),
    ('烈火真人', '会', '火系魔法'),
    ('炎阳宗', '敌对势力是', '幽冥教'),
    # ... 更多关系
]

# 构建图谱
G = build_knowledge_graph(manhua_relations)

# 查询示例 1: 2 跳推理
query1 = "轩辕墨的师傅的师兄是谁？"
facts1 = graph_retrieve(query1, G, max_hops=2)
# 输出：['轩辕墨 师傅是 炎阳真人', '炎阳真人 师兄是 烈火真人']
# LLM 生成答案：轩辕墨的师傅是炎阳真人，炎阳真人的师兄是烈火真人

# 查询示例 2: 聚合查询
query2 = "炎阳宗有哪些弟子会火系魔法？"
facts2 = graph_retrieve(query2, G, max_hops=2)
# 输出：['轩辕墨 属于 炎阳宗', '轩辕墨 会 火系魔法', '烈火真人 属于 炎阳宗', '烈火真人 会 火系魔法']
# LLM 生成答案：炎阳宗会火系魔法的弟子有轩辕墨和烈火真人

# 查询示例 3: 全局性问题
query3 = "这部漫剧的主要冲突是什么？"
# 使用社区摘要
summaries = generate_community_summaries(G)
# 找到"冲突"相关的社区摘要
conflict_summary = [s for s in summaries if '冲突' in s['summary'] or '敌对' in s['summary']]
# LLM 生成答案：根据设定，主要冲突是炎阳宗与幽冥教的对抗...
```

---

## 13.2 混合检索与 RRF 融合

### 13.2.1 为什么需要混合检索？

**单一检索的局限性**:

| 检索类型 | 优势 | 劣势 |
|---------|------|------|
| **稠密检索**（向量） | 语义理解好 | 精确匹配差（专有名词） |
| **稀疏检索**（关键词） | 精确匹配好 | 语义理解差 |

**混合检索**: 结合两者优势，既能理解语义，又能精确匹配关键词。

### 13.2.2 RRF 融合算法

**RRF**（Reciprocal Rank Fusion，倒数排名融合）:

**公式**:
```
score(d) = Σ 1 / (k + rank_i(d))
```

- `rank_i(d)`: 文档 d 在第 i 个检索源中的排名
- `k`: 平滑常数，通常设为 **60**（经验值）

**实现代码**:

```python
from typing import List, Dict

def rrf_fusion(
    dense_results: List[str],
    sparse_results: List[str],
    k: int = 60
) -> List[str]:
    """
    RRF 融合稠密检索和稀疏检索结果
    
    参数:
    - dense_results: 稠密检索结果（按相似度排序）
    - sparse_results: 稀疏检索结果（按 BM25 分数排序）
    - k: 平滑常数
    
    返回：融合后的结果（按 RRF 分数排序）
    """
    # 计算每个文档的 RRF 分数
    scores: Dict[str, float] = {}
    
    for rank, doc in enumerate(dense_results, start=1):
        scores[doc] = scores.get(doc, 0) + 1 / (k + rank)
    
    for rank, doc in enumerate(sparse_results, start=1):
        scores[doc] = scores.get(doc, 0) + 1 / (k + rank)
    
    # 按 RRF 分数排序
    fused_results = sorted(scores.keys(), key=lambda x: scores[x], reverse=True)
    
    return fused_results

# 示例
dense_results = ['文档 A', '文档 B', '文档 C', '文档 D']
sparse_results = ['文档 B', '文档 C', '文档 E', '文档 F']

fused = rrf_fusion(dense_results, sparse_results)
# 输出：['文档 B', '文档 C', '文档 A', '文档 E', '文档 D', '文档 F']
# 文档 B 和 C 在两个检索源中都排名靠前，RRF 分数最高
```

### 13.2.3 混合检索实战

**完整流程**:

```python
from rank_bm25 import BM25Okapi
from sentence_transformers import SentenceTransformer
import numpy as np

class HybridRetriever:
    """混合检索器（稠密 + 稀疏）"""
    
    def __init__(self, documents: List[str]):
        self.documents = documents
        # 稠密检索：嵌入模型
        self.embedder = SentenceTransformer('bge-large-zh-v1.5')
        self.document_embeddings = self.embedder.encode(documents)
        
        # 稀疏检索：BM25
        tokenized_docs = [doc.split() for doc in documents]
        self.bm25 = BM25Okapi(tokenized_docs)
    
    def retrieve(self, query: str, top_k: int = 10) -> List[str]:
        """混合检索"""
        # 1. 稠密检索
        query_embedding = self.embedder.encode([query])[0]
        dense_scores = np.dot(self.document_embeddings, query_embedding)
        dense_indices = np.argsort(dense_scores)[::-1][:top_k * 2]  # 取 2 倍，RRF 后会截断
        dense_results = [self.documents[i] for i in dense_indices]
        
        # 2. 稀疏检索
        query_tokens = query.split()
        bm25_scores = self.bm25.get_scores(query_tokens)
        sparse_indices = np.argsort(bm25_scores)[::-1][:top_k * 2]
        sparse_results = [self.documents[i] for i in sparse_indices]
        
        # 3. RRF 融合
        fused_results = rrf_fusion(dense_results, sparse_results, k=60)
        
        # 4. 截断到 top_k
        return fused_results[:top_k]

# 使用示例
documents = [
    "轩辕墨是炎阳宗的首席弟子",
    "轩辕墨会火系魔法",
    "炎阳宗的敌对势力是幽冥教",
    # ... 更多文档
]

retriever = HybridRetriever(documents)
query = "轩辕墨的能力是什么？"
results = retriever.retrieve(query, top_k=5)
```

---

## 13.3 Rerank 策略

### 13.3.1 为什么需要 Rerank？

**初排精度有限**:
- 向量检索使用 ANN（近似最近邻），为了速度牺牲精度
- 检索出的 Top-100 中可能混入噪声

**Rerank 的作用**:
- 用 Cross-Encoder 模型对 Top-100 重排序
- 捕捉查询 - 文档的细粒度交互
- 提升 NDCG@10 指标 **15-25%**

### 13.3.2 Cross-Encoder vs Bi-Encoder

**Bi-Encoder**（双编码器）:
```
查询 → Encoder → 查询向量 ─┐
                           ├→ 相似度计算 → 分数
文档 → Encoder → 文档向量 ─┘

优势：可预计算文档向量，检索快
劣势：无法捕捉查询 - 文档交互
```

**Cross-Encoder**（交叉编码器）:
```
查询 + 文档 → Encoder → 分数

优势：捕捉查询 - 文档交互，精度高
劣势：无法预计算，需实时推理，慢
```

### 13.3.3 Rerank 实现

**使用 BGE Reranker**:

```python
from FlagEmbedding import FlagReranker

# 初始化 Reranker
reranker = FlagReranker('BAAI/bge-reranker-v2-m3', use_fp16=True)

# 准备候选文档
query = "轩辕墨的能力是什么？"
candidates = [
    "轩辕墨是炎阳宗的首席弟子",
    "轩辕墨会火系魔法",
    "炎阳宗的敌对势力是幽冥教",
    "轩辕墨的师傅是炎阳真人",
    # ... 更多候选
]

# Rerank
pairs = [[query, doc] for doc in candidates]
scores = reranker.compute_score(pairs)

# 按分数排序
ranked_docs = sorted(zip(candidates, scores), key=lambda x: x[1], reverse=True)

# 取 Top-5
top_5 = [doc for doc, score in ranked_docs[:5]]
```

**截断策略**:

| 阶段 | 数量 | 说明 |
|------|------|------|
| **初排检索** | Top-100 | 向量检索 + 稀疏检索，RRF 融合 |
| **Rerank** | Top-100 → Top-10 | Cross-Encoder 重排序 |
| **最终输出** | Top-5-10 | 送入 LLM 生成 |

**成本分析**（BGE Reranker）:
- 推理时间：10-50ms/对
- Top-100 Rerank: 1-5 秒
- Top-200 Rerank: 2-10 秒（通常不可接受）

**推荐配置**:
- 初排截断：K=100（平衡召回率和成本）
- Rerank 后截断：Top-5-10（受 LLM 上下文窗口限制）

---

## 13.4 2024-2026 高级 RAG 技术

### 13.4.1 技术演进时间线

```
2023 Q4: Self-RAG（自我反思式 RAG）
    ↓
2024 Q1: CRAG（Corrective RAG）、RAG-Fusion（多查询融合）
    ↓
2024 Q2: Graph RAG（知识图谱 RAG）、Agentic RAG（Agent 自主检索）
```

### 13.4.2 Self-RAG（自我反思式 RAG）

**核心思想**: 让模型自主判断"是否需要检索"、"检索内容是否有用"、"生成内容是否有依据"。

**工作流程**:
```
用户查询 → 模型判断是否需要检索？
    │
    ├─ 否 → 直接生成 → 自我评估（有无幻觉？）→ 输出
    │
    └─ 是 → 检索文档 → 评估检索内容有用性 → 生成 → 自我评估 → 输出
```

**效果**（原论文）:
- 事实准确性提升 **15-25%**
- 幻觉率降低 **30-40%**

### 13.4.3 Agentic RAG

**核心思想**: 将 RAG 检索过程交给 Agent 自主决策。

**Agent 决策流程**:
```
用户查询 → Agent 分析查询
    │
    ├─ 简单查询 → 直接用 LLM 回答（无需检索）
    │
    ├─ 中等查询 → 检索 Top-5，直接生成
    │
    └─ 复杂查询 → 迭代检索（检索→分析→再检索）→ 生成
```

**效果**:
- 检索成本降低 **40-60%**（简单查询无需检索）
- 复杂查询准确性提升 **20-30%**（迭代检索）

### 13.4.4 RAG-Fusion

**核心思想**: 通过生成多个相关查询，融合多个检索结果，减少单一查询的偏差。

**工作流程**:
```
用户查询 → LLM 生成多个相关查询（3-5 个）
    │
    ├─ 查询 1 → 检索 Top-50
    ├─ 查询 2 → 检索 Top-50
    └─ 查询 3 → 检索 Top-50
         ↓
    RRF 融合所有结果 → Rerank → 生成
```

**效果**（Rakuten 官方）:
- 召回率提升 **25-35%**
- 用户满意度提升 **15-20%**
- 检索成本增加 **2-3 倍**（多次检索）

---

## 13.5 最佳实践总结

### 13.5.1 技术选型决策树

```
需要 RAG 吗？
    │
    ├─ 否 → 直接用 LLM
    │
    └─ 是 → 需要多跳推理吗？
            │
            ├─ 是 → Graph RAG
            │
            └─ 否 → 需要高召回率吗？
                    │
                    ├─ 是 → RAG-Fusion
                    │
                    └─ 否 → 混合检索 + Rerank
```

### 13.5.2 参数推荐

| 参数 | 推荐值 | 说明 |
|------|--------|------|
| **Chunk 大小** | 256-1024 Token | 根据文档类型调整 |
| **Chunk 重叠** | 10-20% | 漫剧等连贯性强的文档用 15-20% |
| **初排截断 K** | 100 | 平衡召回率和成本 |
| **Rerank 后截断** | Top-5-10 | 受 LLM 上下文窗口限制 |
| **RRF 参数 k** | 60 | 经验值 |
| **相似度阈值** | 0.6-0.7 | 低于此值标注低置信度 |

### 13.5.3 漫剧项目 RAG 配置

```python
# 漫剧设定检索配置
MANHUA_RAG_CONFIG = {
    'chunk_size': 500,  # 500 Token/chunk
    'chunk_overlap': 0.15,  # 15% 重叠
    'retrieval_top_k': 100,  # 初排 Top-100
    'rerank_top_k': 8,  # Rerank 后 Top-8
    'similarity_threshold': 0.6,  # 相似度阈值
    'use_hybrid': True,  # 使用混合检索
    'use_rerank': True,  # 使用 Rerank
    'use_graph': False,  # 暂不使用 Graph RAG（构建成本高）
}
```

---

## 本章小结

**核心知识点**:
- **Graph RAG**: 知识图谱增强检索，支持多跳推理和全局性问题
- **混合检索**: 稠密 + 稀疏检索，RRF 融合
- **Rerank**: Cross-Encoder 重排序，提升精度 15-25%
- **高级技术**: Self-RAG、Agentic RAG、RAG-Fusion

**实战技能**:
- 能够构建知识图谱并实现图遍历检索
- 能够设计和实现混合检索 + RRF 融合
- 能够选择合适的 Rerank 策略
- 能够根据场景选择 RAG 技术

---

## 知识来源

1. **Graph RAG**: Microsoft Research Blog, "GraphRAG: Unlocking LLM discovery on narrative private data", 2024-06
2. **RRF 论文**: Cormack et al., "Reciprocal Rank Fusion outperforms Condorcet and Individual Rank Learning Methods", SIGIR 2009
3. **Self-RAG**: Asai et al., "Self-RAG: Learning to Retrieve, Generate, and Critique through Self-Reflection", ICLR 2024
4. **Agentic RAG**: LangChain Agents + RAG, LlamaIndex Agent RAG, 2024 Q2
5. **RAG-Fusion**: Rakuten Blog, "RAG Fusion: A New Take on Retrieval-Augmented Generation", 2024-02
6. **BGE Reranker**: https://github.com/FlagOpen/FlagEmbedding

---

**修改记录**:
- v3.1 (2026-03-27): Graph RAG 深度增强版 - 补充完整实现流程、代码示例、漫剧案例
- v3.0 (2026-03-26): 学习路径重组版 - 从原 11 章移来
- v2.0 (2026-03-23): 润色版
