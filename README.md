# Agent Novel Skill

> **你用 Claude 写小说，是不是经常感觉"写得还行，但一股 AI 味"？**
> 这个 skill 就是为了消灭这种感觉。

一个文件。零依赖。78 章连载实战踩坑提炼。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-blue)](https://claude.com/claude-code)

---

## Before / After

打开仓库第一眼就能看到区别。左边是未经 skill 处理的 AI 腔文本。右边是同一场景，经过 6 条硬性规则 + QC 过滤后的样子。

| Before ❌ | After ✅ |
|-----------|----------|
| 他感到一阵深深的恐惧从心底升起，他觉得自己可能永远也走不出这座死城了。仿佛整个世界都在崩塌。 | 林哲的后背贴着墙。水泥是凉的。他从墙角探出半个头——暗处有东西在动。 |
| 她知道他在害怕，但她同时也知道他是对的。这不是软弱的表现，而是一个人在面对巨大危险时最真实的反应。 | 苏瑶的手按在腰间的撬棍上。金属贴着她掌心的茧——硬的——锈的触感。她的呼吸从鼻子里出来——两次——然后停了。 |

> 完整 Before/After 对比见 [`demo/`](demo/)

**区别在哪？** Before 是叙述者在替角色做总结。After 是读者站在角色的肩膀上看世界。这就是 6 条硬性规则的作用——不靠审美，靠规则。

---

## 这 78 章中我们踩过的 5 个经典坑

不靠"已写 78 章"来证明可靠性。告诉你我们踩了什么坑，以及这个 skill 如何帮你避开。

| 坑 | 表现 | Skill 如何防 |
|----|------|-------------|
| **元叙事污染** | 角色说"这是第12章给你的" | QC 4d 扫描"第X章""前文提到"等模式 |
| **数字不自洽** | "四个字"实际是五个字 | QC 4d 数字声称 vs 实际逐条比对 |
| **物理穿帮** | 5座比亚迪塞了8个人 | current_state.md 维护载具容量，QC 4d 对照检查 |
| **伏笔蒸发** | 40章后忘了20章的约定 | L1 冻结摘要——每章写定冻存，永不丢失 |
| **钩子疲劳** | 连用三次同类型章末钩子 | 6型钩子分类 + 避开前3章已用类型 |

> 详细踩坑集：[`docs/real-pitfalls.md`](docs/real-pitfalls.md)

---

## Quick Start

```bash
git clone https://github.com/[username]/agent-novel.git
cd agent-novel
bash install.sh
```

在 Claude Code 中输入 `写第X章` — skill 自动加载。

**要求**：Claude Code CLI 或 IDE 扩展已安装。不需要 Python、不需要 Node、不需要数据库。

---

## What It Does

```
写第X章
  │
  ├→ 1. 准备  加载 MASTER_SETTING + 世界快照 + 前3章语感
  │           上下文接近15k token时按优先级裁剪
  │
  ├→ 2. 规划  本章核心情绪？情感锚点角色？哪些可以不写？
  │           选钩子类型（避开前3章已用）+ 确认伏笔操作
  │
  ├→ 3. 写作  1800-5000字 · 严格遵守6条硬性规则
  │
  ├→ 4. 质检  4a: quality-check.sh 自动扫描 (7项, 2秒)
  │           4b: 命名一致性目检 (30秒)
  │           4c: 桥段重复目检 (30秒)
  │           4d: 物理/数字/元叙事自洽 (30秒)
  │           不达标→修改→最多3轮→标记[QC-FAIL]→人工裁决
  │
  ├→ 5. 图片  node scripts/convert-to-images.js (可选)
  │
  └→ 6. 更新  按序写入6个追踪文件
              ① chapter_summaries (L1冻结摘要+钩子+桥段标签)
              ② current_state (角色位置/物资/威胁)
              ③ pending_hooks (伏笔推进/回收/新埋)
              ④ subplot_board (支线断档计数)
              ⑤ character_arcs (弧光变化时)
              ⑥ emotional_arcs (感情线变化时)
```

---

## 6 大卖点

### 1. 6 条硬性规则 — 消灭 AI 腔

1. 抽象情绪词 0 容忍（感到/觉得/知道/认为/明白）
2. "不是X是Y"句式 ≤ 2 次/章
3. 同一角色连续说话 ≤ 3 句
4. 段落 ≤ 250 字
5. 同一句式不连续复用
6. 不写角色解释他人心理状态

不靠审美判断，靠规则执行。每条规则都有对应的检测方式。
→ [`docs/6-rules.md`](docs/6-rules.md)

### 2. 5 层质检 — 低级错误归零

- **4a** (自动): quality-check.sh — 7 项指标，2 秒跑完
- **4b** (30s): 命名一致性 — 秦队→秦队长？祺→祁？
- **4c** (30s): 桥段重复 — 最近 20 章同类桥段去重
- **4d** (30s): 物理/数字/元叙事自洽 — 5座车坐不了8个人
- **熔断**: 3 轮未通过 → 标记 [QC-FAIL] → 人工裁决

→ [`docs/qc-system.md`](docs/qc-system.md)

### 3. L1 冻结摘要 — 写到 200 章也不会忘记伏笔

每章写完后 300-500 字摘要，立即冻结，永不回改。
发现错误不覆盖，在 continuity-issues.md 追加修正。
长篇连载的记忆锚点——这是 78 章实战后提炼的最关键机制。

### 4. 爽点梯级 — 爽点不靠灵感

- **战斗** L1-L5: 被碾压 → 险胜 → 智取 → 碾压 → 不战而胜
- **情感** L1-L4: 被理解 → 和解 → 回应 → 清算

每级一行执行指导。不是理论，是 checklist。

### 5. 6 型章末钩子 — 追更不疲劳

信息炸弹 / 悬念断裂 / 情绪共振 / 反差沉默 / 动作戛然 / 命运转折

自动避开前 3 章已用类型，防止钩子疲劳。

### 6. 上下文裁剪规则 — 关键信息永不丢失

上下文接近 15k token 时，按序裁剪：写作指南 → 非出场角色弧光 → 检索结果。
**绝不裁剪** MASTER_SETTING / current_state / 活跃伏笔。
不猜该丢什么——规则说了算。

---

## Tech Stack

```
Claude Code Skill (SKILL.md) + Bash (QC Script) + 6 Markdown 追踪文件
= 零运行时依赖
```

不需要 Python 环境。不需要 Node.js。不需要数据库。不需要 API Key。
唯一的依赖是 Claude Code 本身。

---

## Project Structure

```
agent-novel/
├── README.md              # You are here
├── README_ZH.md           # 中文详细文档
├── SKILL.md               # 核心——放到 ~/.claude/skills/agent-novel/ 即用
├── quality-check.sh       # 7项自动化质检
├── install.sh             # 一键安装
├── CONTRIBUTING.md        # 社区贡献指南
├── LICENSE                # MIT
├── demo/
│   ├── sample-chapter-before.md   # AI腔原始版本
│   └── sample-chapter-after.md    # 规则过滤后版本
├── docs/
│   ├── pipeline.md        # 6步流水线详解
│   ├── 6-rules.md         # 6条硬性规则的设计哲学+踩坑故事
│   ├── qc-system.md       # 5层质检体系说明
│   └── real-pitfalls.md   # 78章连载中踩过的5个经典坑
└── assets/
    ├── poster-prompt.md   # AI海报生成提示词
    ├── banner.png         # GitHub头图
    └── terminal-screenshot.png  # QC通过截图
```

---

## 这个 Skill 不是什么

- ❌ 不是一键生成小说的工具
- ❌ 不是 AI 代笔——AI 写初稿，你（作为作者）做决定
- ❌ 不是"万能写作模板"——它是为**末世/公路/多角色长篇连载**设计的

## 什么时候不该用它

- 短篇小说（< 10 章）— 追踪系统过重
- 单一角色视角 — 多角色交互矩阵闲置
- 非连载写作 — L1 冻结摘要是为长线连载设计的

---

## License

MIT — 随便改、随便用、随便分发。

---

## 链接

- [中文详细文档](README_ZH.md)
- [6步流水线详解](docs/pipeline.md)
- [6条硬性规则的设计哲学](docs/6-rules.md)
- [5层质检体系](docs/qc-system.md)
- [78章踩坑集](docs/real-pitfalls.md)
- [贡献指南](CONTRIBUTING.md)
