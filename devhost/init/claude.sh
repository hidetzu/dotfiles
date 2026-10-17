#!/usr/bin/env bash
# Claude Code のネイティブインストーラを実行（既に入ってればスキップ）
# 公式: https://claude.ai/install.sh

set -euo pipefail

if [ -x "$HOME/.local/bin/claude" ]; then
    echo "==> claude already installed: $("$HOME/.local/bin/claude" --version 2>/dev/null || echo unknown)"
    exit 0
fi

echo "==> Installing Claude Code via official installer..."
curl -fsSL https://claude.ai/install.sh | bash
