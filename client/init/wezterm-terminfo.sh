#!/usr/bin/env bash
# wezterm 用 terminfo を ~/.terminfo にインストール。
# client の WezTerm は config.term = "wezterm" にしているので、手元に terminfo が要る (macOS には入っていない)。
# 既に入っていれば (ncurses にあるときも) スキップ。
# 目的: nvim 等が DECSET 2026 (synchronized output) を使えるようにし、
#       split/scroll 時の描画ズレを防ぐ。

set -euo pipefail

if infocmp wezterm >/dev/null 2>&1; then
    echo "==> wezterm terminfo already installed"
    exit 0
fi

if ! command -v tic >/dev/null 2>&1; then
    echo "==> tic not found; install ncurses first" >&2
    exit 1
fi

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

echo "==> Downloading wezterm.terminfo..."
curl -fsSL -o "$tmpfile" \
    https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo

echo "==> Compiling with tic..."
tic -x -o "$HOME/.terminfo" "$tmpfile"

echo "==> wezterm terminfo installed to ~/.terminfo"
