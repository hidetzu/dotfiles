#!/usr/bin/env bash
# ~/.claude/settings.json が、今のリポジトリから生成した物と同じかを確かめる。
# 違えば差分を出す（Claude Code の /config などで書き換えられた分は、リポジトリへ戻してから deploy する）。
# autoMode は機械ごとの物なので比べない。
set -euo pipefail

# shellcheck source=devhost/claude-settings.sh
. "$DOTPATH/devhost/claude-settings.sh"

if [ ! -f "$CLAUDE_SETTINGS" ] || [ -L "$CLAUDE_SETTINGS" ]; then
    echo "NG .claude/settings.json (not generated; run make deploy)"
    exit 1
fi
if diff -u --label generated --label .claude/settings.json \
    <(generate_claude_settings | jq -S .) <(strip_auto_mode "$CLAUDE_SETTINGS"); then
    echo "ok .claude/settings.json (generated)"
else
    echo "NG .claude/settings.json differs from generated (上の差分をリポジトリへ戻すか、make deploy で上書きする)"
    exit 1
fi
