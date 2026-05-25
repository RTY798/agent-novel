# AI 海报生成提示词

> **核心策略**：AI 生图不生成复杂中文文字（会乱码）。所有图片 = AI 生成气氛背景 + 设计工具（Canva/Figma/PS）手动叠加文字。最终效果反而更专业、更可控。

---

## 场景 1：GitHub 仓库头图（1280×640）

### AI 生图提示词

```
A minimalist dark banner for GitHub repo. Center: glowing hexagonal circuit-board symbol with a classic fountain pen nib at its exact center, golden light radiating outward. Left side: six vertical translucent geometric bars in warm gradient colors (amber to gold), no text on them. Right side: empty dark space reserved for text overlay. Background: deep navy (#0a0a1a) with subtle dot-grid pattern, faint golden particles floating upward like embers from a dying fire. Clean tech-literature fusion aesthetic. No text, no letters, no characters anywhere in the image. Style: cinematic, professional, warm-but-precise. --ar 128:64
```

### 后期叠加（Canva/Figma）

使用思源黑体（或 Inter / SF Pro Display）叠加以下文字：

| 位置 | 内容 | 字号/样式 |
|------|------|----------|
| 右侧居中 | **AGENT NOVEL SKILL** | 48pt Bold |
| 右侧副标题 | One File. Zero Dependencies. | 18pt Light |
| 底部标签 | Claude Code Skill · v8.0 | 12pt 细体 |

---

## 场景 2：社交媒体宣传图（1080×1080）

### AI 生图提示词

```
A striking dark background image for social media. A writer's wooden desk seen from above — an open leather-bound notebook, a fountain pen resting diagonally, a half-empty glass of whiskey, warm lamplight casting long shadows. On the notebook page: completely blank (no text, no writing). The scene feels intimate, focused, slightly melancholic. Outside the depth of field: a window showing a faint post-apocalyptic skyline silhouette. Color palette: warm amber light versus cold blue outside. No text, no letters, no characters anywhere. Photographic quality, shallow depth of field. --ar 1:1 --style photographic
```

### 后期叠加（Canva/Figma）

| 位置 | 内容 | 样式 |
|------|------|------|
| 顶部大字 | AI写小说（"AI"红色删除线，右边手写体"你"） | 64pt Bold + 手写字体 |
| 中间副标题 | Agent Novel Skill — Claude Code 小说创作技能 | 20pt Regular |
| 底部标签行 | 消灭AI腔 · 78章实战踩坑 · 一个文件零依赖 | 14pt Light |

---

## 场景 3：终端截图（真正的杀手级素材）

这个**不用 AI 生成**——直接截取 Claude Code 实际运行界面。

### 截图 1：Skill 自动加载

Claude Code 中输入 "写第78章" 后的提示——显示 agent-novel skill 已自动加载。

### 截图 2：QC 通过

```bash
bash scripts/quality-check.sh "chapters/第78章-长乐余烬.md"
```

输出示例：
```
==========================================
质检: 第78章-长乐余烬.md
==========================================
PASS: ——数量 = 28 (20-35)
PASS: 不是/是句式 = 1 (≤2)
PASS: 抽象情绪词 = 0
PASS: 正文字数 = 3247 (1500-5000)
PASS: 一句话段 = 23 (≥5)
PASS: 最长段落 = 178字 (≤250字)
PASS: 连续4逗号无句号 = 0
==========================================
结果: ALL PASS ✓ (7/7)
```

### 制作

将截图 1 + 截图 2 拼接为竖版长图，上下排列。
加简单标注箭头 + 文字说明（用 Canva/PPT 即可，不需要 AI）。
这是对技术受众最有说服力的素材——不是设计稿，是真实跑通的结果。

---

## 为什么要"纯视觉 + 后期加字"

1. AI 生图模型对中文文字的生成极不稳定——99% 会出乱码或鬼画符
2. 即使英文文字，复杂排版（竖条上的微文字）也会变形
3. 后期加字反而给了你完全的设计控制权：字体、字号、间距、对齐
4. 最终的图看起来更专业——因为没有"半成品感"

**流程**：AI 生成气氛背景 → 导入 Canva/Figma → 叠加文字层 → 导出 PNG
总时间约 10 分钟。比反复修改提示词企图让 AI 画出正确的文字快得多。
