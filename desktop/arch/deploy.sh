#!/usr/bin/env bash
# MacBook のトラックパッドの設定を kcminputrc に書く。
# kcminputrc は KWin が書き換えるので symlink にせず、ここに挙げたキーだけを上書きする。
# 動いている KWin には伝えないので、次のログインから効く。Plasma が無ければ何もしない。
set -euo pipefail

command -v kwriteconfig6 >/dev/null || exit 0

set_trackpad() {
    kwriteconfig6 --file kcminputrc \
        --group Libinput --group 1452 --group 636 \
        --group "Apple Inc. Apple Internal Keyboard / Trackpad" \
        --key "$1" "$2"
}

set_trackpad NaturalScroll true
set_trackpad TapToClick true
set_trackpad TapAndDrag true
set_trackpad LmrTapButtonMap false # 2 本指のタップで右クリック
set_trackpad ClickMethod 2         # 2 本指で押し込むと右クリック
set_trackpad PointerAcceleration 0.000
set_trackpad ScrollFactor 1
echo "write .config/kcminputrc (trackpad)"
