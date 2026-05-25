#!/bin/bash
# Agent Novel Skill v9.0 — 通用安装脚本
# 支持 Claude Code / Cursor / Windsurf / 任意 AI Agent
# 用法: bash install.sh [目标目录]
#   不传参数: 安装到 Claude Code 默认目录 (~/.claude/skills/agent-novel)
#   传目录: 安装到指定目录 (如 bash install.sh ~/.cursor/rules/agent-novel)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 目标目录：参数传入，或默认 Claude Code skill 目录
if [ -n "$1" ]; then
    SKILL_DIR="$1"
else
    SKILL_DIR="$HOME/.claude/skills/agent-novel"
fi

echo "============================================"
echo " Agent Novel Skill v9.0 — 安装"
echo "============================================"
echo ""
echo " 目标目录: $SKILL_DIR"
echo ""

# 检测 Agent 类型
case "$SKILL_DIR" in
    *cursor*)  AGENT_TYPE="Cursor" ;;
    *windsurf*) AGENT_TYPE="Windsurf" ;;
    *claude*)  AGENT_TYPE="Claude Code" ;;
    *)         AGENT_TYPE="自定义 Agent" ;;
esac
echo " 检测到 Agent 类型: $AGENT_TYPE"
echo ""

# 1. 安装 SKILL.md
echo "[1/3] 安装 SKILL.md ..."
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "  ✓ SKILL.md 已安装"

# 2. 安装 references/（渐进披露文件）
echo ""
echo "[2/3] 安装 references/（渐进披露·9个文件）..."
mkdir -p "$SKILL_DIR/references"
cp "$SCRIPT_DIR/references/"*.md "$SKILL_DIR/references/"
echo "  ✓ references/ 已安装（$(ls "$SCRIPT_DIR/references/"*.md 2>/dev/null | wc -l) 个文件）"

# 3. 安装 templates/（Bootstrap模板）
echo ""
echo "[3/3] 安装 templates/（Bootstrap模板·2个文件）..."
mkdir -p "$SKILL_DIR/templates"
cp "$SCRIPT_DIR/templates/"*.md "$SKILL_DIR/templates/"
echo "  ✓ templates/ 已安装（$(ls "$SCRIPT_DIR/templates/"*.md 2>/dev/null | wc -l) 个文件）"

echo ""
echo "============================================"
echo " 安装完成！"
echo ""
echo " 平台: $AGENT_TYPE"
echo ""
echo " 开始写作："
echo "   输入 \"开始新小说项目\" 或 \"我想写一本小说\""
echo "   Skill 自动引导 4 问 → 生成完整项目 → 说 \"写第1章\" 开始"
echo ""
echo " 续写章节："
echo "   输入 \"写第X章\" 或 \"写下一章\""
echo ""
echo " 诊断小说："
echo "   输入 \"诊断小说\" 或 \"检查健康度\""
echo ""
echo " 手动质检："
echo "   复制 quality-check.sh 到你的项目 scripts/ 目录"
echo "   bash scripts/quality-check.sh chapters/第X章.md"
echo ""
echo " 支持平台: Claude Code · Cursor · Windsurf · 任意 Agent"
echo "============================================"
