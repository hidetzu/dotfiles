#!/usr/bin/env bash
# OpenAI Codex CLI のインストール（既に入ってればスキップ）
# GitHub releases の latest tarball を取得して ~/.local/bin に配置
# https://github.com/openai/codex/releases

set -euo pipefail

if [ -x "$HOME/.local/bin/codex" ]; then
    echo "==> codex already installed: $("$HOME/.local/bin/codex" --version 2>/dev/null || echo unknown)"
    exit 0
fi

os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)

case "$os" in
    darwin) target_os=apple-darwin ;;
    linux)  target_os=unknown-linux-musl ;;
    *) echo "Unsupported OS: $os" >&2; exit 1 ;;
esac

case "$arch" in
    arm64|aarch64) target_arch=aarch64 ;;
    x86_64|amd64)  target_arch=x86_64 ;;
    *) echo "Unsupported arch: $arch" >&2; exit 1 ;;
esac

asset="codex-${target_arch}-${target_os}.tar.gz"
url="https://github.com/openai/codex/releases/latest/download/${asset}"
dest="$HOME/.local/bin"

mkdir -p "$dest"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "==> Downloading $asset..."
curl -fsSL -o "$tmp/$asset" "$url"
tar -xzf "$tmp/$asset" -C "$tmp"

binary=$(find "$tmp" -maxdepth 2 -type f -perm -u+x -name 'codex*' ! -name '*.tar.gz' | head -1)
if [ -z "${binary:-}" ] || [ ! -f "$binary" ]; then
    echo "Could not locate codex binary inside tarball" >&2
    exit 1
fi

install -m 0755 "$binary" "$dest/codex"
echo "==> codex installed to $dest/codex"
