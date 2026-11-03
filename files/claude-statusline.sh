#!/usr/bin/env bash
# Claude Code status line: session title | model | context tokens | cost
in=$(cat)
[ -n "$CLAUDE_STATUSLINE_DEBUG" ] && printf '%s' "$in" > "$CLAUDE_STATUSLINE_DEBUG"

tp=$(jq -r '.transcript_path // empty' <<<"$in")
title=$(jq -r '.session_name // .session_title // empty' <<<"$in")
if [ -z "$title" ] && [ -f "$tp" ]; then
  # custom title (/rename) wins over the auto-generated one; take the latest
  title=$(tac "$tp" | jq -r 'select(.type=="custom-title") | .customTitle' 2>/dev/null | head -1)
  [ -z "$title" ] && title=$(tac "$tp" | jq -r 'select(.type=="ai-title") | .aiTitle' 2>/dev/null | head -1)
fi

fmt() { awk -v n="$1" 'BEGIN{ if(n>=1000000) printf "%.1fM",n/1e6; else if(n>=1000) printf "%.1fk",n/1e3; else printf "%d",n }'; }

model=$(jq -r '.model.display_name // .model.id // "?"' <<<"$in")
used=$(jq -r '.context_window.used_percentage // empty' <<<"$in")
size=$(jq -r '.context_window.context_window_size // empty' <<<"$in")
cost=$(jq -r '.cost.total_cost_usd // empty' <<<"$in")
l5=$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$in")
l7=$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$in")

out=""
[ -n "$title" ] && out="$title | "
out+="$model"
if [ -n "$used" ]; then
  out+=" | ctx ${used}%"
  [ -n "$size" ] && out+=" ($(fmt "$(awk -v p="$used" -v s="$size" 'BEGIN{printf "%d",p*s/100}')")/$(fmt "$size"))"
fi
[ -n "$cost" ] && out+=" | \$$(printf '%.2f' "$cost")"
[ -n "$l5" ] && out+=" | 5h ${l5}%"
[ -n "$l7" ] && out+=" | 7d ${l7}%"
printf '%s' "$out"
