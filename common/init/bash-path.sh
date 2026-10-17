#!/usr/bin/env bash
# bash の PATH に ~/.local/bin を追加（claude/codex 等が入る場所）
# .bashrc と .profile 両方に冪等に追記する

set -euo pipefail

marker='# dotfiles: ensure ~/.local/bin in PATH'
block='[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"'

for rcfile in "$HOME/.bashrc" "$HOME/.profile"; do
    touch "$rcfile"
    if grep -Fq "$marker" "$rcfile"; then
        continue
    fi
    {
        echo ""
        echo "$marker"
        echo "$block"
    } >> "$rcfile"
    echo "==> Added ~/.local/bin to PATH in $rcfile"
done
