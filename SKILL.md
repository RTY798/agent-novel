# Agent Novel Skill v9.0 — 万能小说创作技能

> 从一句话想法到完整项目。任意类型。6条规则过滤AI腔。写作技法库支撑质量。

---

## 启动模式

### Bootstrap：开始新小说项目
触发：用户说"开始新小说/我想写小说/创建小说项目"

```
第1轮（4个必答问题）：
  ① 小说标题/暂定名
  ② 类型/风格：[奇幻/都市/古风/科幻/悬疑/末世/言情/历史/武侠/轻小说/其他]
  ③ 一句话核心前提（可填"未定"）
  ④ 主角名字+一句话标签（如"林晚，末世快递员"）

→ 收集完毕 → 自动生成最小可用项目（目录结构+MASTER_SETTING+所有追踪文件）
→ 提示："说'写第1章'开始，或说'完善设定'深入规划"

第2轮（可选·仅当用户说"完善设定"/"帮我详细规划"时触发）：
  目标规模 / 叙事视角 / 世界观类型 / 主要冲突类型 / 配角 / 类型特定信息
  （奇幻：魔法体系？言情：CP数量？科幻：技术设定？悬疑：核心谜团？……）
```

Bootstrap 使用 `templates/MASTER_SETTING.template.md` 和 `templates/project-files.template.md`（按 `### FILE:` 分隔符拆分为8个文件）。

### Write：继续写章节
触发：用户说"写第X章/写下一章/续写" → 执行6步流水线。

---

## 6条通用硬性规则（基线）

1. **抽象情绪词0容忍**：感到/觉得/知道/认为/明白 — 禁止出现在叙述中
2. **"不是X是Y"句式 ≤ 2次/章**
3. **同一角色连续说话 ≤ 3句**（中间必须插入动作/环境/沉默）
4. **段落 ≤ 250字**
5. **同一句式不连续复用**（开头/结尾/段落结构）
6. **不写角色解释他人心理状态**

> 各类型的调整建议见 `references/writing-rules.md`（建议，非强制。最终裁决权在作者。）

## 禁用词表（通用基线）
- 抽象情绪：感到、觉得、知道、认为、明白
- AI腔：仿佛、似乎、在...中
- 各类型特有禁用词见 `references/genre-guide.md`

---

## 6步流水线

### 1. 准备
- 必须加载：MASTER_SETTING + current_state + 前3章节选 + `references/writing-techniques.md`
- 按需加载：tracking/下对应文件 + arc_maps/arc_map_卷X.md
- 裁剪规则：上下文接近15k token时，按序裁剪——①非出场角色弧光 ②检索结果。**绝不裁剪** MASTER_SETTING / current_state / 活跃伏笔 / writing-techniques.md

### 2. 规划

**L0写作意图卡（本章写前必填）**：
```
1. 核心情绪：[1个词]
2. 情感锚点角色：[角色名]
3. 节拍预排（本章预计4-6个节拍）：
   | 节拍 | 1句话概括 | 感官主导 | 情绪负荷 |
   |  1   |           | 视觉/听觉/触觉/嗅觉 | 高/中/低 |
   |  2   |           |          |          |
4. 删减清单：[哪些可以不写？]
5. 伏笔操作：[本章回收/推进/新埋的伏笔编号]
```
+ 钩子类型选择（避开前3章已用类型，参考 `references/hook-types.md`）
+ 节奏模型选择（上升型/下降型，参考 `references/rhythm-models.md`）

### 3. 写作
1800-5000字，严格遵守6条硬性规则 + `references/writing-techniques.md` 写作技法。

### 4. 质检
- **4a**：运行 quality-check.sh（7项自动扫描，2秒）。不达标→修改→最多3轮。第3轮仍未通过→标记[QC-FAIL]→人工裁决，不阻塞流水线。
- **4a2**：韵律粗检（30秒·非硬性）。扫描段落长度标准差+连续短句（≤8字）计数。仅统计输出，不判定PASS/FAIL。
- **4b**：命名一致性（30秒）。扫本章人名/地名，确认无意外变体。
- **4c**：桥段重复（30秒）。对照 chapter_summaries.md 最近20章[桥段类型]标签。
- **4d**：物理/数字/元叙事自洽（30秒）。数字声称 vs 实际一致；物理约束合理；无"第X章""前文提到"等元叙事用语。

详细说明见 `references/qc-rules.md`。

### 5. 图片
node scripts/convert-to-images.js（可选）

### 6. 更新（按序写入6个追踪文件）
① chapter_summaries.md — 追加 [L1冻结摘要]（300-500字，写定后永不回改）+ 钩子类型 + [桥段类型]标签
② current_state.md — 更新角色位置/团队状态/物资/威胁
③ pending_hooks.md — 伏笔推进/回收/新埋
④ subplot_board.md — Strand Weave日志+断档计数
⑤ character_arcs.md — 仅当弧光状态变化时更新
⑥ emotional_arcs.md — 仅当感情线/爽点状态变化时更新

如后续发现L1冻结摘要中的事实错误，在 logs/continuity-issues.md 登记，不覆盖已冻结的L1。

---

## 渐进披露引用

| 文件 | 何时读取 | 内容 |
|------|---------|------|
| `references/writing-techniques.md` | **每次写章节必读** | 感官/对话/节奏/叙述距离/场景结构/情感传达/描写·写作技法库 |
| `references/writing-rules.md` | Bootstrap + 换类型时 | 各类型对6条规则的调整建议+原理 |
| `references/pleasure-points.md` | 规划爽点场景时 | 战斗L1-L5+情感L1-L4，每级执行指导 |
| `references/hook-types.md` | 规划钩子时 | 6型钩子详解+各类型推荐配比+疲劳避免 |
| `references/narrator-modes.md` | 规划叙述距离时 | 贴着/退后/记忆介入·三模式适用场景 |
| `references/qc-rules.md` | 质检时 | 5层质检完整说明 |
| `references/genre-guide.md` | Bootstrap + 写章节时 | 各类型写作要点/常见陷阱/禁用词差异 |
| `references/rhythm-models.md` | 规划节拍时 | 2个通用节奏模型（上升型/下降型） |
| `references/novel-doctor-checklist.md` | 用户说"诊断小说"时 | 6项人工检查清单 |

---

## 诊断

用户说"诊断小说"/"检查健康度" → 加载 `references/novel-doctor-checklist.md`，逐项执行6项人工检查（段落呼吸/对话叙述平衡/感官切换/情绪曲线/钩子疲劳/伏笔密度）。

## 定期检查（触发条件见项目CLAUDE.md）
每5章或卷末：对照 constitution/HARD_INVARIANTS.md 执行4项健康度检查（可读性/承诺违背/节奏/冲突真空），结果追加到 logs/health-check-log.md。
