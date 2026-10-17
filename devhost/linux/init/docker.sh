#!/usr/bin/env bash
# docker のデーモンを有効化する（systemd が動いていない環境、例えばコンテナでは飛ばす）
set -euo pipefail

if [ ! -d /run/systemd/system ]; then
    echo "==> systemd not running; skip enabling docker"
    exit 0
fi
sudo systemctl enable docker --now
