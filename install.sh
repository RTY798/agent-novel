#!/bin/bash
# Agent Novel Skill v9.0 — 一键安装脚本
# 将 SKILL.md + references/ + templates/ 复制到 Claude Code 的 skill 目录
# 可选：在当前目录创建新小说项目（从模板生成）

set -e

SKILL_DIR="$HOME/.claude/skills/agent-novel"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "============================================"
echo " Agent Novel Skill v9.0 — 安装"
echo "============================================"
echo ""

# 1. 安装 SKILL.md
echo "[1/3] 安装 SKILL.md 到 $SKILL_DIR ..."
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "  ✓ SKILL.md 已安装"

# 2. 安装 references/（渐进披露文件）
echo ""
echo "[2/3] 安装 references/ ..."
mkdir -p "$SKILL_DIR/references"
cp "$SCRIPT_DIR/references/"*.md "$SKILL_DIR/references/"
echo "  ✓ references/ 已安装（$(ls "$SCRIPT_DIR/references/"*.md | wc -l) 个文件）"

# 3. 安装 templates/（Bootstrap模板）
echo ""
echo "[3/3] 安装 templates/ ..."
mkdir -p "$SKILL_DIR/templates"
cp "$SCRIPT_DIR/templates/"*.md "$SKILL_DIR/templates/"
echo "  ✓ templates/ 已安装（$(ls "$SCRIPT_DIR/templates/"*.md | wc -l) 个文件）"

echo ""
echo "============================================"
echo " 安装完成！"
echo ""
echo " 开始写作："
echo "   在 Claude Code 中输入 \"开始新小说项目\" 或 \"我想写一本小说\""
echo "   Skill 会自动引导 4 问 → 生成完整项目 → 说 \"写第1章\" 开始"
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
echo "============================================"
