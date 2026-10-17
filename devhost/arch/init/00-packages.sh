#!/usr/bin/env bash
set -euo pipefail

PKGS="base-devel git fish go neovim fzf jq docker ripgrep docker-compose fd tree-sitter-cli yazi mise unzip starship github-cli gopls lua-language-server typescript-language-server pyright"

# データベースを取り直すなら、システム全体も上げてから入れる (-Syu)。
# -Sy だけで入れると partial upgrade になり、Arch ではサポートされない
# shellcheck disable=SC2086
sudo pacman -Syu --needed --noconfirm $PKGS
