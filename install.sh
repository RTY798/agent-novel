#!/bin/bash
# Agent Novel Skill — 一键安装脚本
# 将 SKILL.md 复制到 Claude Code 的 skill 目录
# 将 quality-check.sh 复制到当前项目的 scripts/ 目录

set -e

SKILL_DIR="$HOME/.claude/skills/agent-novel"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "============================================"
echo " Agent Novel Skill v8.0 — 安装"
echo "============================================"
echo ""

# 1. 安装 SKILL.md
echo "[1/2] 安装 SKILL.md 到 $SKILL_DIR ..."
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "  ✓ SKILL.md 已安装"

# 2. 提示 quality-check.sh
echo ""
echo "[2/2] quality-check.sh 已就绪"
echo "  复制到你的小说项目: cp \"$SCRIPT_DIR/quality-check.sh\" <你的项目>/scripts/"
echo ""
echo "============================================"
echo " 安装完成！"
echo ""
echo " 使用方法："
echo "   在 Claude Code 中输入 \"写第X章\""
echo "   skill 会自动加载。"
echo ""
echo " 手动质检："
echo "   bash scripts/quality-check.sh chapters/第X章.md"
echo "============================================"
