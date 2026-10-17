#!/usr/bin/env bash
# ~/.claude/settings.json は symlink にせず、公開の設定に非公開の設定（あれば）を重ねて生成する。
# 生成した時の写しを .settings.json.generated に残し、Claude Code が書き換えた分は check で差分として出す。
# autoMode は機械ごとの物なので、今のファイルにあればそのまま引き継ぐ。
set -euo pipefail

# shellcheck source=devhost/claude-settings.sh
. "$DOTPATH/devhost/claude-settings.sh"

mkdir -p "$HOME/.claude"
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
jq -s '.[0] * .[1]' <(generate_claude_settings) <(current_auto_mode) > "$tmp"

# 生成した後に書き換えられていた（あるいは以前の symlink の実体だった）なら、上書きする前に退避する
if [ -L "$CLAUDE_SETTINGS" ]; then
    rm "$CLAUDE_SETTINGS"
elif [ -f "$CLAUDE_SETTINGS" ] && ! cmp -s <(strip_auto_mode "$CLAUDE_SETTINGS") <(strip_auto_mode "$tmp") \
    && { [ ! -f "$CLAUDE_SETTINGS_REF" ] || ! cmp -s <(strip_auto_mode "$CLAUDE_SETTINGS") <(strip_auto_mode "$CLAUDE_SETTINGS_REF"); }; then
    backup="$CLAUDE_SETTINGS.bak.$(date +%Y%m%d%H%M%S)"
    cp "$CLAUDE_SETTINGS" "$backup"
    echo "backup .claude/settings.json -> ${backup}（生成後に書き換えられていた分。必要ならリポジトリへ戻す）"
fi

install -m 644 "$tmp" "$CLAUDE_SETTINGS"
cp "$CLAUDE_SETTINGS" "$CLAUDE_SETTINGS_REF"
echo "generate .claude/settings.json"
