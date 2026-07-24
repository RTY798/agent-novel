# ✍️ Agent Novel Framework

> **让 AI 负责记忆、校验与首稿；让作者继续负责选择、判断与文学性。**

[![Version](https://img.shields.io/badge/version-v12.0-7c3aed?style=flat-square)](https://github.com/RTY798/agent-novel/releases)
[![Node.js](https://img.shields.io/badge/Node.js-20%2B-339933?style=flat-square&logo=node.js&logoColor=white)](https://nodejs.org/)
[![License](https://img.shields.io/badge/license-MIT-0ea5e9?style=flat-square)](LICENSE)
[![Language](https://img.shields.io/badge/docs-中文优先-f59e0b?style=flat-square)](README_ZH.md)

一个面向 **Claude Code、Codex、Cursor、Windsurf** 等 Agent 的长篇小说创作框架。它不把“禁词表”当文学，也不让模型拿着整本设定盲目续写；它用一套轻量、可验证的工作流，让百章之后的人物、物资、伏笔、时间线和故事承诺仍然站得住。

**[快速开始](#-30-秒开始)** · **[核心工作流](#-核心工作流)** · **[v12-为什么不同](#-v12-为什么不同)** · **[完整中文指南](README_ZH.md)** · **[Agent 指令](SKILL.md)**

---

## 你会得到什么

| 不再依赖 | v12 提供 |
|---|---|
| “把全书设定贴给 AI，然后说续写” | HOT / WARM / COLD 分层上下文，只加载本章需要的事实。 |
| 靠感觉记住角色位置、物资与伤势 | `story-state.json` + 追加式 `chapter-log.jsonl`，事实可追溯。 |
| 所有章节都套同一份写作流程 | A 情绪章 / B 动作章 / C 桥接章，按章节功能切换工作流。 |
| 用破折号数、禁词表判断好不好看 | 事实错误严格拦截；风格信号只供编辑判断。 |
| 让模型走“最顺、最安全”的剧情 | 关键分歧先给 A/B/C 三案，由作者选择真正符合人物的一案。 |

## 🧭 核心工作流

```mermaid
flowchart LR
    A[作者确定本章目标] --> B[章节卡\n目标·阻力·选择·后果]
    B --> C[加载 HOT + WARM 上下文]
    C --> D[AI 输出场景节拍]
    D --> E[作者确认关键选择]
    E --> F[AI 生成首稿]
    F --> G[事实门禁 + 叙事审稿]
    G --> H[作者定稿]
    H --> I[追加章节日志\n更新故事状态]
```

这里最重要的原则只有一句：

> **事实是数据，文字是艺术。**
>
> 人物位置、物资消耗、伤势、已知信息必须严格；句长、破折号、直接情绪词和段落节奏则必须尊重作品语境。

## ⚡ 30 秒开始

```bash
git clone https://github.com/RTY798/agent-novel.git
cd agent-novel
npm install

# 创建新小说项目
npm run init -- "我的小说"

# 验证故事状态与章节卡
npm run check:state -- "projects/我的小说/state/story-state.json"
npm run check:card -- "projects/我的小说/cards/ch-001.md"
```

然后把 [章节卡模板](templates/chapter-card.template.md) 和当前状态交给你的 Agent：

```text
使用这张章节卡和允许事实，先给我 3—5 个“目标 → 阻力 → 选择 → 后果”的场景节拍。
不要直接写正文；等我确认不可逆选择后，再生成首稿和独立的 STATE_DELTA。
```

<details>
<summary><strong>第一次建书需要填什么？</strong></summary>

只需要五项：书名、类型与目标读者、一句话前提、主角不可变锚点、预计篇幅。先写出第一章，再逐步扩展世界观；不要在正文开始前制造一部无人验证的百科全书。

</details>

## ✨ v12 为什么不同

v12 保留了旧版最有效的机制：**三型分流、唯一画面、Story Contract、事件冷却、分层记忆、冻结摘要与连贯性门禁**。但也做了几项决定性的修正：

| 旧问题 | v12 的处理 |
|---|---|
| 形式化规则会把文字写僵 | 禁词、段落长度和标点频率改为观察项，不再单独退稿。 |
| “每章必须新增悬念”制造钩子疲劳 | 章节只需要留下真实变化；解决问题、休整和支付代价同样有价值。 |
| “完全免检”会让长篇状态漂移 | 创作释放章可以跳过风格检查，但永远保留事实门禁。 |
| 为躲检测刻意留下错别字 | 彻底删除：作品质量不该为检测让路。 |
| 未核验的研究数字被写成结论 | 改为可验证的设计假设与可复查的项目指标。 |

## 🧩 目录一览

```text
agent-novel/
├── SKILL.md                    # 交给 Agent 的完整工作指令
├── README_ZH.md                # 完整中文方法论
├── templates/                  # 新项目、状态、章节卡、审稿模板
├── scripts/                    # 零依赖 Node.js 初始化与校验脚本
├── references/                 # 章节类型、上下文、质检、三案决策
├── examples/                   # 可直接参考的章节卡
├── docs/                       # 旧版实战资料与场景示例
└── demo/                       # 修改前后的文本示例
```

## ✅ 什么会阻断发布，什么不会

| 阻断项：必须修 | 观察项：由作者判断 |
|---|---|
| 人物不可能地出现在两地 | 段落长短与句长分布 |
| 物资、人数、伤势无来源地变化 | 破折号、常见副词、直接情绪词 |
| 角色在未获得信息前作出反应 | 对话比例、感官比例、留白多少 |
| 章节卡承诺的关键后果未写入日志 | 某个词或某种句式出现次数 |

这套边界是框架的核心：**自动化应该抓住客观错误，而不是假装能替人判断文学。**

## 📝 写给 Agent 的一句话

```text
只能使用章节卡里的允许事实；不确定的设定标记 [NEEDS_LOOKUP] 并检索，
不得因为“看起来合理”而补写。先给节拍，作者确认后再写正文。
```

完整指令见 [SKILL.md](SKILL.md)。想理解状态结构、三型章节、审稿政策和项目健康度，请阅读 [完整中文指南](README_ZH.md)。

## 🤝 贡献

欢迎提交模板、脚本、示例和可复现的失败案例。新增规则前请先说明它解决的具体问题与维护成本；没有可验证失败案例的规则，应当保持为建议，而非门禁。

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## License

[MIT](LICENSE) © 2026 RTY798
