#!/usr/bin/env bash
# zemo CLI のインストール（既に入ってればスキップ）
# GitHub releases の latest tarball を取得して ~/.local/bin に配置
# https://github.com/hidetzu/zemo/releases

set -euo pipefail

if [ -x "$HOME/.local/bin/zemo" ]; then
    echo "==> zemo already installed: $("$HOME/.local/bin/zemo" --version 2>/dev/null || echo unknown)"
    exit 0
fi

os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)

case "$os" in
    darwin) target_os=macos ;;
    linux)  target_os=linux-gnu ;;
    *) echo "Unsupported OS: $os" >&2; exit 1 ;;
esac

case "$arch" in
    arm64|aarch64) target_arch=aarch64 ;;
    x86_64|amd64)  target_arch=x86_64 ;;
    *) echo "Unsupported arch: $arch" >&2; exit 1 ;;
esac

# zemo は aarch64-linux のリリース未配布
if [ "$target_os" = "linux-gnu" ] && [ "$target_arch" = "aarch64" ]; then
    echo "zemo does not provide aarch64-linux release; build from source." >&2
    exit 1
fi

asset_dir="zemo-${target_arch}-${target_os}"
asset="${asset_dir}.tar.gz"
url="https://github.com/hidetzu/zemo/releases/latest/download/${asset}"
dest="$HOME/.local/bin"

mkdir -p "$dest"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "==> Downloading $asset..."
curl -fsSL -o "$tmp/$asset" "$url"
tar -xzf "$tmp/$asset" -C "$tmp"

install -m 0755 "$tmp/${asset_dir}/zemo" "$dest/zemo"
echo "==> zemo installed to $dest/zemo"
