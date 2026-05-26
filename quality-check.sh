#!/bin/bash
# quality-check.sh — 章节质量自动检查
# 用法: bash scripts/quality-check.sh "chapters/第X章-标题.md"
# 输出: 逐项PASS/FAIL + 最终结果

if [ -z "$1" ]; then
    echo "用法: bash scripts/quality-check.sh <章节文件路径>"
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "文件不存在: $FILE"
    exit 1
fi

CONTENT=$(cat "$FILE")
# 去掉markdown标题行、空行、分隔线的纯正文
BODY=$(echo "$CONTENT" | grep -v '^#' | grep -v '^---$' | grep -v '^$')

FAILS=0
CHECKS=0

echo "=========================================="
echo "质检: $(basename "$FILE")"
echo "=========================================="

# 1. 破折号数量 (建议20-35，通讯章/内心独白章≤50。弹性警告，不FAIL)
CHECKS=$((CHECKS + 1))
DASH=$(echo "$CONTENT" | grep -o '——' | wc -l)
if [ "$DASH" -lt 20 ]; then
    echo "PASS: ——数量 = $DASH (≥20)"
elif [ "$DASH" -gt 50 ]; then
    echo "⚠️ WARNING: ——数量 = $DASH (偏多，建议≤50。通讯章/内心独白章可放宽)"
elif [ "$DASH" -gt 35 ]; then
    echo "⚠️ WARNING: ——数量 = $DASH (偏多，建议20-35。如为通讯章/内心独白章可接受)"
else
    echo "PASS: ——数量 = $DASH (20-35)"
fi

# 2. "不是X是Y"句式 (要求≤2，统计包含"不是....是"的行)
CHECKS=$((CHECKS + 1))
NOT_IS=$(echo "$BODY" | grep -c '不是.*是')
if [ "$NOT_IS" -gt 2 ]; then
    echo "FAIL: 不是/是句式 = $NOT_IS (要求 ≤2)"
    FAILS=$((FAILS + 1))
else
    echo "PASS: 不是/是句式 = $NOT_IS (≤2)"
fi

# 3. 抽象情绪词 (要求0·仅检查叙述，排除对话)
CHECKS=$((CHECKS + 1))
# 先去掉对话内容（中文引号内的文本），再检查叙述中的情绪词
NARRATIVE_BODY=$(echo "$BODY" | sed 's/"[^"]*"//g' | sed 's/「[^」]*」//g')
EMO=$(echo "$NARRATIVE_BODY" | grep -o -E '感到|觉得|知道|认为|明白|理解|害怕|难过|愤怒|紧张|伤心|恐惧|焦虑|悲伤|开心' | wc -l)
if [ "$EMO" -gt 0 ]; then
    echo "FAIL: 抽象情绪词(叙述) = $EMO (要求 0)"
    echo "  出现词汇: $(echo "$NARRATIVE_BODY" | grep -o -E '感到|觉得|知道|认为|明白|理解|害怕|难过|愤怒|紧张|伤心|恐惧|焦虑|悲伤|开心' | sort | uniq -c | sort -rn | head -5)"
    FAILS=$((FAILS + 1))
else
    echo "PASS: 抽象情绪词(叙述) = 0"
fi

# 4. 字数 (要求1500-5000，只统计纯正文·用Python计数Unicode字符)
CHECKS=$((CHECKS + 1))
CHARS=$(python3 -c "import sys; print(len(sys.stdin.read().strip()))" <<< "$BODY" 2>/dev/null || echo -n "$BODY" | wc -m)
if [ "$CHARS" -lt 1500 ]; then
    echo "FAIL: 正文字数 = $CHARS (要求 ≥1500)"
    FAILS=$((FAILS + 1))
elif [ "$CHARS" -gt 5000 ]; then
    echo "FAIL: 正文字数 = $CHARS (要求 ≤5000)"
    FAILS=$((FAILS + 1))
else
    echo "PASS: 正文字数 = $CHARS (1500-5000)"
fi

# 5. 一句话段数量 (要求≥5)
# 统计：被空行包围的、非标题/非分隔符、长度<80字符的单行段落
CHECKS=$((CHECKS + 1))
ONE_LINERS=$(awk '
  BEGIN { RS="\n\n"; count=0 }
  {
    gsub(/^[[:space:]\n]+|[[:space:]\n]+$/, "")
    lines = split($0, a, "\n")
    if (lines == 1 && length($0) > 0 && length($0) < 80 && $0 !~ /^#/ && $0 != "---") {
      count++
    }
  }
  END { print count+0 }
' "$FILE")
if [ "$ONE_LINERS" -lt 5 ]; then
    echo "FAIL: 一句话段 = $ONE_LINERS (要求 ≥5)"
    FAILS=$((FAILS + 1))
else
    echo "PASS: 一句话段 = $ONE_LINERS (≥5)"
fi

# 6. 最长段落字符数 (要求≤250字，约等于手机屏10行·用Python计数)
CHECKS=$((CHECKS + 1))
MAX_PARA_CHARS=$(python3 -c "
import sys
text = open(sys.argv[1], 'r', encoding='utf-8').read()
paras = [p.strip().replace('\n','') for p in text.split('\n\n') if p.strip() and not p.strip().startswith('#') and p.strip() != '---']
print(max((len(p) for p in paras), default=0))
" "$FILE" 2>/dev/null || awk '
  BEGIN { RS="\n\n"; max=0 }
  {
    gsub(/^[[:space:]\n]+|[[:space:]\n]+$/, "")
    if ($0 == "" || $0 ~ /^#/ || $0 == "---") next
    gsub(/\n/, "", $0)
    if (length($0) > max) max = length($0)
  }
  END { print max+0 }
' "$FILE")
if [ "$MAX_PARA_CHARS" -gt 250 ]; then
    echo "FAIL: 最长段落 = ${MAX_PARA_CHARS}字 (要求 ≤250字)"
    FAILS=$((FAILS + 1))
else
    echo "PASS: 最长段落 = ${MAX_PARA_CHARS}字 (≤250字)"
fi

# 7. 连续逗号检测 (禁止连续4个逗号无句号)
CHECKS=$((CHECKS + 1))
CONSECUTIVE_COMMAS=0
while IFS= read -r line; do
    # 去掉非正文行
    [[ "$line" =~ ^# ]] && continue
    [[ "$line" =~ ^---$ ]] && continue
    [[ -z "$line" ]] && continue
    # 统计这行中逗号数量，如果≥4且没有句号，标记
    COMMA_COUNT=$(echo "$line" | grep -o '，' | wc -l)
    HAS_PERIOD=$(echo "$line" | grep -c '。')
    if [ "$COMMA_COUNT" -ge 4 ] && [ "$HAS_PERIOD" -eq 0 ]; then
        CONSECUTIVE_COMMAS=$((CONSECUTIVE_COMMAS + 1))
    fi
done < "$FILE"

if [ "$CONSECUTIVE_COMMAS" -gt 0 ]; then
    echo "FAIL: 连续4逗号无句号 = ${CONSECUTIVE_COMMAS}行 (要求 0)"
    FAILS=$((FAILS + 1))
else
    echo "PASS: 连续4逗号无句号 = 0"
fi

# ==========================================
# 8-9. 韵律粗检（非硬性·仅统计输出）
# ==========================================

# 8. 段落长度标准差（仅统计，不判定PASS/FAIL）
echo "---"
PARA_STATS=$(awk '
  BEGIN { RS="\n\n"; count=0; sum=0; sumsq=0 }
  {
    gsub(/^[[:space:]\n]+|[[:space:]\n]+$/, "")
    if ($0 == "" || $0 ~ /^#/ || $0 == "---") next
    gsub(/\n/, "", $0)
    len = length($0)
    if (len > 0) {
      count++
      sum += len
      sumsq += len * len
      lens[count] = len
    }
  }
  END {
    if (count == 0) { print "0 0 0 0 0"; exit }
    mean = sum / count
    if (count == 1) { print mean " 0 " lens[1] " " lens[1] " 1"; exit }
    variance = (sumsq - (sum*sum/count)) / (count - 1)
    sd = sqrt(variance)
    # 找最小和最大段落长度
    min_len = lens[1]; max_len = lens[1]
    for (i=2; i<=count; i++) {
      if (lens[i] < min_len) min_len = lens[i]
      if (lens[i] > max_len) max_len = lens[i]
    }
    print mean " " sd " " min_len " " max_len " " count
  }
' "$FILE")

MEAN=$(echo "$PARA_STATS" | awk '{printf "%.0f", $1}')
SD=$(echo "$PARA_STATS" | awk '{printf "%.0f", $2}')
MIN_PARA=$(echo "$PARA_STATS" | awk '{print $3}')
MAX_PARA=$(echo "$PARA_STATS" | awk '{print $4}')
PARA_COUNT=$(echo "$PARA_STATS" | awk '{print $5}')

RHYTHM_NOTE=""
if [ "$PARA_COUNT" -gt 3 ] && [ "$SD" != "0" ]; then
  if [ "$SD" -lt 35 ]; then
    RHYTHM_NOTE=" [节奏-平头] 段落长度过于均匀(标准差=${SD})，可能缺少节奏变化"
  elif [ "$SD" -gt 90 ]; then
    RHYTHM_NOTE=" [节奏-剧烈] 段落长度极不均匀(标准差=${SD})，检查是否有意为之"
  else
    RHYTHM_NOTE=" 分布自然"
  fi
fi
echo "统计: 段落数=${PARA_COUNT} 均值=${MEAN}字 标准差=${SD} 最短=${MIN_PARA}字 最长=${MAX_PARA}字"
echo "      ${RHYTHM_NOTE}"

# 9. 连续短句计数（≤8字·连续3句以上为一组，仅统计）
SHORT_SENTENCE_GROUPS=$(awk '
  BEGIN { RS="\n\n"; group_count=0 }
  {
    gsub(/^[[:space:]\n]+|[[:space:]\n]+$/, "")
    if ($0 == "" || $0 ~ /^#/ || $0 == "---") next
    # 按句号、问号、感叹号、破折号分句
    line = $0
    gsub(/\n/, "", line)
    n = split(line, sents, /[。？！——]/)
    consecutive = 0
    for (i=1; i<=n; i++) {
      sub(/^[[:space:]]+/, "", sents[i])
      if (length(sents[i]) > 0 && length(sents[i]) <= 8) {
        consecutive++
      } else {
        if (consecutive >= 3) group_count++
        consecutive = 0
      }
    }
    if (consecutive >= 3) group_count++
  }
  END { print group_count+0 }
' "$FILE")

TOTAL_CHARS=$(echo -n "$BODY" | wc -m)
PER_1000=$(awk -v g="$SHORT_SENTENCE_GROUPS" -v c="$TOTAL_CHARS" 'BEGIN { if (c>0) printf "%.1f", g*1000/c; else print "0" }')

echo "统计: 连续短句组(≤8字×≥3句) = ${SHORT_SENTENCE_GROUPS}组 (${PER_1000}组/千字)"
if [ "$(echo "$PER_1000 > 5" | bc -l 2>/dev/null || echo 0)" = "1" ]; then
  echo "      [提示] 短句组偏多，可能碎片化节奏"
elif [ "$(echo "$PER_1000 < 2 && $TOTAL_CHARS > 2000" | bc -l 2>/dev/null || echo 0)" = "1" ]; then
  echo "      [提示] 短句组偏少，可能缺少节奏变化"
else
  echo "      节奏变化在正常区间"
fi

# ============================================
# Check 10: 五感覆盖率统计（非PASS/FAIL，仅统计输出）
# ============================================
echo "=== Check 10: 五感覆盖率 ==="
VISUAL=$(grep -c -E '看到|看见|光|暗|黑|白|红|灰|蓝|绿|黄|橙' "$1")
AUDIO=$(grep -c -E '听到|声音|响|静|咕嘟|滴答|砰|咔|嗡|沙沙' "$1")
TOUCH=$(grep -c -E '摸|握|碰|凉|热|冰|软|硬|硌|湿|干|黏' "$1")
SMELL=$(grep -c -E '闻到|气味|辣味|香味|臭味|汽油|铁锈|松针|烧焦|霉' "$1")
TASTE=$(grep -c -E '尝|吃|喝|甜|辣|咸|酸|苦|涩|话梅|草莓|茶' "$1")

SENSES_USED=0
[ "$VISUAL" -gt 0 ] && ((SENSES_USED++))
[ "$AUDIO" -gt 0 ] && ((SENSES_USED++))
[ "$TOUCH" -gt 0 ] && ((SENSES_USED++))
[ "$SMELL" -gt 0 ] && ((SENSES_USED++))
[ "$TASTE" -gt 0 ] && ((SENSES_USED++))

echo "  视觉关键词: $VISUAL 次"
echo "  听觉关键词: $AUDIO 次"
echo "  触觉关键词: $TOUCH 次"
echo "  嗅觉关键词: $SMELL 次"
echo "  味觉关键词: $TASTE 次"
echo "  覆盖感官: $SENSES_USED/5"

if [ "$SENSES_USED" -lt 3 ]; then
    echo "  ⚠️ 警告：五感覆盖不足(<3种)。建议在情感爆点处增加非视觉感官描写。"
    echo "  参考：references/golden-finger-techniques.md → 手法1：五感沉浸"
fi

# 角色专属动作检测（非PASS/FAIL，仅统计提醒）
CHARACTER_GESTURES=$(grep -c -E '咬笔|打火机|菜单本|耳机|钢管|虎牙|狗牌|蓝布条|碎镜子|弯管|撬棍|琴颈|对讲机.*攥|手指.*敲' "$1")
echo "  角色专属动作/物品关键词: $CHARACTER_GESTURES 次"
if [ "$CHARACTER_GESTURES" -eq 0 ]; then
    echo "  ⚠️ 未检测到角色专属动作关键词。建议检查情感爆点处是否使用了通用动作('握拳''咬牙')替代角色专属微动作。"
fi

# ============================================
# Check 11: 连续对话段落预警
# ============================================
echo "=== Check 11: 连续对话预警 ==="
# 检测连续4行以上纯对话：用awk统计连续以中文引号/对话标点开头的行
CONSECUTIVE_COUNT=$(grep -n -E '^("[^"]*"|"[^"]*|——|[^"]*")$|^".*"$' "$1" | awk -F: '{
    if(prev_line && $1==prev_line+1) {
        consecutive++
    } else {
        if(consecutive>=4) print "连续"consecutive"行对话(起始行"start_line")"
        consecutive=1; start_line=$1
    }
    prev_line=$1
} END { if(consecutive>=4) print "连续"consecutive"行对话(起始行"start_line")" }')
if [ -n "$CONSECUTIVE_COUNT" ]; then
    echo "  ⚠️ 检测到连续对话段落，需人工确认："
    echo "$CONSECUTIVE_COUNT"
    echo "  检查项：是否有角色连续说话>3句？是否需要插入动作/环境/内心戏打破纯对话节奏？"
fi

# 汇总
echo "=========================================="
if [ "$FAILS" -eq 0 ]; then
    echo "结果: ALL PASS ✓ (${CHECKS}/${CHECKS})"
    exit 0
else
    echo "结果: FAIL — ${FAILS}/${CHECKS} 项未通过"
    exit 1
fi
