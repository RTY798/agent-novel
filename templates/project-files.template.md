### FILE: CLAUDE.md

# {{TITLE}} 项目编排器

## 当前进度
卷一 | Ch.0/{{TOTAL_CHAPTERS}} (0%) | 项目刚创建，待写Ch.1

## 写章节流程

### 写前准备
1. Agent Novel Skill v9.0 已自动加载（6条硬性规则+6步流水线+写作技法库）
2. 必须加载：
   - constitution/MASTER_SETTING.md（人物宪法+世界观+交互矩阵）
   - tracking/current_state.md（世界快照：角色位置/物资/威胁）
   - 前3章正文首尾各100字（吸收语感）
3. 按需加载（仅当本章涉及时才Read，不涉及则跳过）：
   - 出场角色弧光状态 → tracking/character_arcs.md
   - 感情线推进 → tracking/emotional_arcs.md
   - 伏笔操作 → tracking/pending_hooks.md
   - 支线平衡 → tracking/subplot_board.md
   - 卷级弧光规划 → arc_maps/arc_map_卷X.md
   - 写作技法 → skill的 references/writing-techniques.md（每次写章节时必读）

### 写后追踪更新（按序写入，非并行）
1. tracking/chapter_summaries.md — 追加 [L1冻结摘要]（300-500字，写定冻存）+钩子类型+[桥段类型]标签
2. tracking/current_state.md — 更新角色位置/团队状态/物资/威胁
3. tracking/pending_hooks.md — 伏笔推进/回收/新埋
4. tracking/subplot_board.md — Strand Weave日志+断档计数更新
5. tracking/character_arcs.md — 仅当弧光状态变化时更新
6. tracking/emotional_arcs.md — 仅当感情线/爽点状态变化时更新

### 写后检查触发
- 若本章编号为5的倍数或卷终章，追加一步：
  对照 constitution/HARD_INVARIANTS.md 执行4项健康度检查（可读性/承诺违背/节奏/冲突真空），
  结果追加到 logs/health-check-log.md。

## 连续性日志
若写后校验或后续章节发现 L1 冻结摘要中的事实错误，在 logs/continuity-issues.md 追加一条记录（含日期+章节+错误描述+修正），不覆盖已冻结的 L1。

## 诊断
说"诊断小说"/"检查健康度" → 加载 skill 的 references/novel-doctor-checklist.md 执行6项人工检查。

## 不写章节时
- 讨论剧情/角色/伏笔 → 不加载SKILL.md，直接讨论
- 质量检测 → 加载SKILL.md，运行 scripts/quality-check.sh
- 规划弧光/大纲 → 按需Read对应文件
- 施工日志 → 更新 logs/施工日志.md

## 文件索引
| 用途 | 路径 |
|------|------|
| 宪法设定 | constitution/MASTER_SETTING.md |
| 硬性红线 | constitution/HARD_INVARIANTS.md |
| 世界快照 | tracking/current_state.md |
| 章纲+L1摘要+桥段标签 | tracking/chapter_summaries.md |
| 伏笔体系 | tracking/pending_hooks.md |
| 支线面板 | tracking/subplot_board.md |
| 角色弧光 | tracking/character_arcs.md |
| 感情线+爽点 | tracking/emotional_arcs.md |
| 弧光地图 | arc_maps/ |
| 大纲 | outlines/ |
| 施工日志 | logs/施工日志.md |
| 健康度日志 | logs/health-check-log.md |
| 连续性登记 | logs/continuity-issues.md |

### FILE: .project.md

# 项目索引（.project.md）

> {{TITLE}} 完整目录结构 | v9.0写作框架 | Agent Novel Skill
> 创建：{{CREATE_DATE}} | 类型：{{GENRE}}

---

## 目录结构

```
{{TITLE}}/
├── .project.md              ← 本文件（项目索引+自动化流程）
├── CLAUDE.md                ← 项目编排器
├── constitution/            ← 宪法级文件（写作前必读，只读）
├── tracking/                ← 6文件追踪系统（每章按序读写）
├── chapters/                ← 正文章节（每章写入）
├── images/                  ← 章节图片（可选输出）
├── arc_maps/                ← 弧光地图（每卷初写入）
├── outlines/                ← 大纲与结构
├── logs/                    ← 施工日志+健康度日志+连续性登记
└── scripts/                 ← 质检+图片生成脚本
```

---

## 一、宪法级文件（写前必读·每章）

| 文件 | 用途 | 更新频率 |
|------|------|---------|
| [`constitution/MASTER_SETTING.md`](constitution/MASTER_SETTING.md) | 合同种子——不可变的角色/世界观/伏笔/写作宪法 | 建书定稿，修改需审批 |
| [`constitution/HARD_INVARIANTS.md`](constitution/HARD_INVARIANTS.md) | 4条跨章健康度检查——可读性/承诺/节奏/冲突 | 每5章/卷末 |

---

## 二、追踪文件系统（每章读写·6文件）

| # | 文件 | 用途 | 更新频率 |
|---|------|------|---------|
| ① | [`tracking/chapter_summaries.md`](tracking/chapter_summaries.md) | 章节摘要+L1冻结摘要+钩子+桥段标签 | 每章追加 |
| ② | [`tracking/current_state.md`](tracking/current_state.md) | 当前世界状态（位置/物资/载具/已知信息） | 每章 |
| ③ | [`tracking/pending_hooks.md`](tracking/pending_hooks.md) | 伏笔清单 | 每章 |
| ④ | [`tracking/subplot_board.md`](tracking/subplot_board.md) | 支线进度+Strand Weave+断档计数 | 每章 |
| ⑤ | [`tracking/character_arcs.md`](tracking/character_arcs.md) | 角色弧光三拍子（起点→打破→重建） | 每卷初/弧光变化时 |
| ⑥ | [`tracking/emotional_arcs.md`](tracking/emotional_arcs.md) | 感情线+爽点体系 | 每卷初/感情线变化时 |

---

## 三、v9.0 自动化写作流水线

```
收到"写第X章"
  │
  ├→ 1. 准备：
  │     Agent Novel Skill v9.0 自动加载
  │     必须加载：constitution/MASTER_SETTING.md + tracking/current_state.md + 前3章节选
  │               + skill的 references/writing-techniques.md
  │     按需加载：tracking/下对应文件 + arc_maps/arc_map_卷X.md
  │     裁剪规则：上下文接近15k token时，按序裁剪→写作指南→非出场角色弧光→检索结果
  │
  ├→ 2. 规划：
  │     L0写作意图卡（核心情绪+情感锚点+节拍预排4-6+删减清单+伏笔操作）
  │     钩子类型选择（避开前3章已用）+ 节奏模型选择（上升型/下降型）
  │
  ├→ 3. 写作：正文 → chapters/第X章-标题.md（1800-5000字·6条硬性规则+写作技法）
  │
  ├→ 4. 质检：
  │     a. bash scripts/quality-check.sh "chapters/第X章-标题.md"（7+2项，2秒）
  │        不达标→修改→最多3轮。3轮仍未通过→标记[QC-FAIL]→人工裁决，不阻塞流水线
  │     a2. 韵律粗检（30秒）：段落长度标准差+连续短句计数（非PASS/FAIL，仅统计）
  │     b. 命名一致性目检（30秒）：扫本章主要人名/地名
  │     c. 桥段重复目检（30秒）：对照chapter_summaries.md最近20章[桥段类型]标签
  │     d. 物理/数字/元叙事自洽（30秒）：数字声称/物理约束/元叙事用语
  │
  ├→ 5. 图片生成：node scripts/convert-to-images.js X（可选）
  │
  └→ 6. 更新（按序写入）：
       ① chapter_summaries.md — 追加L1冻结摘要+钩子+[桥段类型]
       ② current_state.md — 更新角色位置/物资/威胁
       ③ pending_hooks.md — 伏笔推进/回收/新埋
       ④ subplot_board.md — Strand Weave+断档计数
       ⑤ character_arcs.md — 仅当弧光状态变化时
       ⑥ emotional_arcs.md — 仅当感情线/爽点变化时

每5章或卷末：对照 HARD_INVARIANTS.md 执行4项健康度检查 → logs/health-check-log.md
```

---

## 四、每卷开始前

```
1. 写弧光地图 → arc_maps/arc_map_卷X.md
2. 核对 tracking/character_arcs.md ——确认本卷打破/重建节点
3. 核对 tracking/emotional_arcs.md ——确认本卷感情线核心冲突
```

---

## 五、关键规则速记

| 规则 | 阈值 | 来源 |
|------|------|------|
| A线断档上限 | ≤5章 | Strand Weave |
| B线断档上限 | ≤10章 | Strand Weave |
| C线断档上限 | ≤15章 | Strand Weave |
| 物件伏笔上限 | 12条活跃 | MASTER_SETTING |
| 钩子类型重复 | 避开前3章已用类型 | hook-types.md |
| 每章必须有冲突 | 外部/内部/人际至少其一 | HARD-004 |
| "不是X是Y" | ≤2次/章 | 硬性规则 |
| 抽象情绪词 | 0容忍（感到/觉得/知道/认为/明白） | 硬性规则 |
| 同一角色连续说话 | ≤3句 | 硬性规则 |
| 段落长度 | ≤250字 | 硬性规则 |
| 字数 | 1800-5000/章 | 质量控制 |
| 审查迭代上限 | 3轮 | 质量控制 |
| 一句话段 | ≥5 | QC脚本 |
| L1冻结摘要 | 300-500字/章 | 每章追加 |

---

## 六、脚本速查

```bash
# 质检
bash scripts/quality-check.sh "chapters/第X章-标题.md"

# 生成单章图片（可选）
node scripts/convert-to-images.js X
```

---

*创建时间：{{CREATE_DATE}} | Agent Novel Skill v9.0 自动生成*

### FILE: tracking/chapter_summaries.md

# 章节摘要追踪

> L1冻结摘要（300-500字）+ 钩子类型 + 桥段标签 | 每章追加 | 写定冻存永不回改

---

| 章 | 标题 | L1冻结摘要 | 钩子类型 | 桥段类型 | 字数 | QC |
|----|------|-----------|---------|---------|------|-----|
| — | — | — | — | — | — | — |

<!--
填写格式示例：
| 1 | 末日降临 | 欧阳在宿舍打完最后一局游戏...（300-500字摘要） | 悬念断裂 | 逃亡·集结 | 3247 | PASS 7/7 |
-->

### FILE: tracking/current_state.md

# 当前世界状态

> 每章更新 | 角色位置/团队状态/物资/威胁/已知信息

---

## 角色位置与状态

| 角色 | 位置 | 状态 | 备注 |
|------|------|------|------|
| {{PROTAGONIST_NAME}} | [待定] | 正常 | — |

## 团队状态
- 总人数：[待定]
- 伤者：无
- 失踪/离队：无

## 物资清单

| 类别 | 物品 | 数量 | 备注 |
|------|------|------|------|
| 水 | [待定] | [待定] | |
| 食物 | [待定] | [待定] | |
| 武器 | [待定] | [待定] | |
| 载具 | [待定] | [待定·容量：[待定]座] | |

## 当前威胁
- 无（第1章开始前）

## 最近事件
- {{CREATE_DATE}}：项目创建

## 已知信息（角色已知·非读者已知）
- [待定]

### FILE: tracking/pending_hooks.md

# 伏笔清单

> 每章更新 | 物件伏笔上限12条 | 超限先回收再新埋

---

## 活跃伏笔

| # | 伏笔名称 | 埋设章 | 计划回收章 | 当前状态 | 最后推进章 | 备注 |
|---|---------|--------|-----------|---------|-----------|------|
| — | — | — | — | — | — | — |

## 已回收伏笔

| # | 伏笔名称 | 埋设章 | 回收章 | 回收方式 |
|---|---------|--------|--------|---------|
| — | — | — | — | — |

## 情感伏笔（独立追踪·不占物件伏笔位）

| 代号 | 内容 | 埋设章 | 计划回收章 | 状态 |
|------|------|--------|-----------|------|
| — | — | — | — | — |

## 伏笔统计
- 活跃物件伏笔：0/12
- 活跃情感伏笔：0
- 超30章未推进：无

### FILE: tracking/subplot_board.md

# 支线进度面板

> Strand Weave 支线编织 | 每章更新断档计数 | A线≤5章 B线≤10章 C线≤15章

---

## 支线定义

| 线级 | 内容 | 断档上限 |
|------|------|---------|
| A线（主线） | [待定] | ≤5章 |
| B线（重要支线） | [待定] | ≤10章 |
| C线（背景支线） | [待定] | ≤15章 |

## 断档计数

| 线级 | 最后出现章 | 当前断档 | 状态 |
|------|-----------|---------|------|
| A线 | — | 0 | ✅ |
| B线 | — | 0 | ✅ |
| C线 | — | 0 | ✅ |

<!--
断档达到上限的80%时标记⚠️，达到上限时标记🔴
-->

## 每章Strand Weave日志

| 章 | A线 | B线 | C线 | 备注 |
|----|-----|-----|-----|------|
| — | — | — | — | — |

### FILE: tracking/character_arcs.md

# 角色弧光追踪

> 弧光三拍子：起点 → 打破 → 重建 | 每卷初更新 | 变化时更新

---

<!--
每角色格式：
### 角色名
- **起点**（卷初状态）：[描述]
- **打破**（本卷触发事件）：[章节·事件]
- **重建**（本卷新平衡）：[章节·新状态]
- **全书终点**（预期）：[最终状态]
-->

### {{PROTAGONIST_NAME}}
- **起点**：[待定]
- **打破**：[待定]
- **重建**：[待定]
- **全书终点**：[待定]

### FILE: tracking/emotional_arcs.md

# 感情线与爽点追踪

> 感情线三阶段 + 爽点体系 | 每卷初更新 | 变化时更新

---

## 感情线状态

<!--
格式：
### 感情线名称（角色A↔角色B）
- 类型：[恋人/兄弟/师徒/...]
- 阶段：确认期 / 裂痕期 / 重建期
- 当前状态：[描述]
- 最近推进章：[章号]
-->

[待定·暂无感情线登记]

## 爽点日志

| 章 | 类型（战斗/情感） | 梯级（L1-L5/L1-L4） | 描述 |
|----|------------------|---------------------|------|
| — | — | — | — |

## 爽点统计
- 战斗爽点：0次（分布：L1:0 L2:0 L3:0 L4:0 L5:0）
- 情感爽点：0次（分布：L1:0 L2:0 L3:0 L4:0）
