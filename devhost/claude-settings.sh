# shellcheck shell=bash
# devhost/deploy.sh と check.sh から読む。
# shellcheck disable=SC2034  # 変数は読む側で使う

CLAUDE_SETTINGS="$HOME/.claude/settings.json"
CLAUDE_SETTINGS_REF="$HOME/.claude/.settings.json.generated"

# 公開の設定に、非公開の設定を深くマージする（オブジェクトは再帰的に重ね、配列は非公開側で置き換える）
# autoMode は機械ごとに Claude Code が書く物なので、リポジトリでは持たない（生成物からも外す）
generate_claude_settings() {
    local base="$DOTPATH/devhost/claude/settings.json"
    local private="$DOTFILES_PRIVATE/devhost/claude/settings.json"
    if [ -f "$private" ]; then
        jq -s '.[0] * .[1] | del(.autoMode)' "$base" "$private"
    else
        jq 'del(.autoMode)' "$base"
    fi
}

# 比べる時は autoMode を外し、キーの順も揃える
strip_auto_mode() {
    jq -S 'del(.autoMode)' "$1"
}

# 今の settings.json にある autoMode だけを取り出す（無ければ空のオブジェクト）
current_auto_mode() {
    if [ -f "$CLAUDE_SETTINGS" ] && [ ! -L "$CLAUDE_SETTINGS" ]; then
        jq 'if has("autoMode") then {autoMode} else {} end' "$CLAUDE_SETTINGS"
    else
        echo '{}'
    fi
}
