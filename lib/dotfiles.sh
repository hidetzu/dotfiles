#!/usr/bin/env bash
# dotfiles の deploy / check / init / list。
# 役割 (client, devhost) と OS で、使う設定の層を選ぶ。common は常に入る。
#
#   usage: lib/dotfiles.sh <deploy|check|init|list> [role...]
#
# 層: <role>/<platform>/ と <role>/。platform は mac / arch と、その上の linux。
# 各層は、このリポジトリと非公開リポジトリ ($DOTFILES_PRIVATE、既定は ~/dotfiles-private。無ければ飛ばす) の両方から読む。
# 各層に置けるもの:
#   links      "その層のリポジトリからのパス  $HOME からのパス" を 1 行ずつ（$HOME 側は空白を含んでよい）
#   deploy.sh  links を張ったあとに走る
#   check.sh   check で links の確認のあとに走る
#   init/*.sh  init で名前順に走る（platform の層が先。パッケージを先に入れるため）

set -euo pipefail

DOTPATH=$(cd "$(dirname "$0")/.." && pwd)
DOTFILES_PRIVATE=${DOTFILES_PRIVATE:-$HOME/dotfiles-private}
if [ -d "$DOTFILES_PRIVATE" ]; then
    DOTFILES_PRIVATE=$(cd "$DOTFILES_PRIVATE" && pwd)
fi
export DOTPATH DOTFILES_PRIVATE

platforms() {
    case "$(uname -s)" in
        Darwin) echo mac ;;
        Linux)
            if [ -f /etc/arch-release ]; then
                echo "arch linux"
            else
                echo linux
            fi
            ;;
        *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
    esac
}

# 役割を指定しなければ、Mac は手元 (client)、Linux は devhost
default_roles() {
    if [ "$(uname -s)" = Darwin ]; then echo client; else echo devhost; fi
}

roots() {
    echo "$DOTPATH"
    if [ -d "$DOTFILES_PRIVATE" ]; then echo "$DOTFILES_PRIVATE"; fi
}

# 層のディレクトリを絶対パスで返す
layers() {
    local role p root
    for role in common $ROLES; do
        for p in $PLATFORMS; do
            for root in $(roots); do
                if [ -d "$root/$role/$p" ]; then echo "$root/$role/$p"; fi
            done
        done
        for root in $(roots); do
            if [ -d "$root/$role" ]; then echo "$root/$role"; fi
        done
    done
}

# 出力: "<絶対パスの src> <$HOME からの dest>"
# 同じ dest が複数の層にあれば、後に読んだ方だけを残す。公開側の層を全部読んでから非公開側を読むので、非公開側が勝つ
read_links() {
    local layer
    for layer in $(echo "$LAYERS" | grep -v "^$DOTFILES_PRIVATE/") $(echo "$LAYERS" | grep "^$DOTFILES_PRIVATE/"); do
        read_layer_links "$layer"
    done | awk '{ s = $1; d = $0; sub(/^[^ ]+ /, "", d); src[d] = s; if (!(d in seen)) { seen[d] = 1; order[++n] = d } } END { for (i = 1; i <= n; i++) print src[order[i]], order[i] }'
}

read_layer_links() {
    local layer=$1 root src dest
    [ -f "$layer/links" ] || return 0
    # 非公開側が先（CI の fixture のように、公開側の中に置かれることがある）
    case "$layer" in
        "$DOTFILES_PRIVATE"/*) root=$DOTFILES_PRIVATE ;;
        *) root=$DOTPATH ;;
    esac
    while read -r src dest; do
        echo "$root/$src $dest"
    done < <(grep -vE '^[[:space:]]*(#|$)' "$layer/links")
}

link() {
    local src="$1" dest="$HOME/$2"
    if [ ! -e "$src" ]; then
        echo "missing source: $src" >&2
        return 1
    fi
    mkdir -p "$(dirname "$dest")"
    # symlink でない実体は、同じ中身のファイルでない限り退避してから張る
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        if [ -f "$dest" ] && cmp -s "$src" "$dest"; then
            rm "$dest"
        else
            local backup
            backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
            mv "$dest" "$backup"
            echo "backup $2 -> $backup"
        fi
    fi
    ln -sfn "$src" "$dest"
    echo "link $2 -> ${src/#"$HOME"/\~}"
}

# リポジトリの中を指して切れている symlink を消す（ファイルを移した後の残骸）
prune() {
    local dir l root
    for dir in "$HOME" "$HOME/.config" "$HOME/.config/fish" "$HOME/.config/git/hooks" "$HOME/.config/gh" "$HOME/.config/wezterm-mux" "$HOME/.claude" "$HOME/.local/bin"; do
        [ -d "$dir" ] || continue
        for l in "$dir"/* "$dir"/.[!.]*; do
            [ -L "$l" ] || continue
            [ -e "$l" ] && continue
            for root in "$DOTPATH" "$DOTFILES_PRIVATE"; do
                case "$(readlink "$l")" in
                    "$root"/*) rm "$l"; echo "prune ${l#"$HOME"/}"; break ;;
                esac
            done
        done
    done
}

run_hooks() {
    local name=$1 layer fail=0
    for layer in $LAYERS; do
        if [ -f "$layer/$name" ]; then bash "$layer/$name" || fail=1; fi
    done
    return "$fail"
}

describe() {
    local private=none
    if [ -d "$DOTFILES_PRIVATE" ]; then private=${DOTFILES_PRIVATE/#"$HOME"/\~}; fi
    echo "roles=[$ROLES] platforms=[$PLATFORMS] private=[$private]"
}

cmd_deploy() {
    echo "==> deploy: $(describe)"
    local src dest
    while read -r src dest; do
        link "$src" "$dest"
    done < <(read_links)
    prune
    run_hooks deploy.sh
}

cmd_check() {
    echo "==> check: $(describe)"
    local src dest fail=0
    while read -r src dest; do
        if [ -L "$HOME/$dest" ] && [ "$(readlink "$HOME/$dest")" = "$src" ] && [ -e "$HOME/$dest" ]; then
            echo "ok $dest"
        else
            echo "NG $dest (want -> $src)"
            fail=1
        fi
    done < <(read_links)
    run_hooks check.sh || fail=1
    return "$fail"
}

cmd_list() {
    read_links
}

cmd_init() {
    echo "==> init: $(describe)"
    # sudo を一度だけ聞き、終わるまで裏で延長する（brew の cask や pacman で何度も聞かれないように）
    if [ "$(id -u)" != 0 ]; then
        sudo -v || { echo "sudo authentication failed" >&2; exit 1; }
        (
            while true; do
                sudo -n true
                sleep 60
                kill -0 "$$" 2>/dev/null || exit
            done
        ) 2>/dev/null &
        # trap は関数を抜けた後に走るので local にしない
        KEEPALIVE_PID=$!
        trap 'kill "$KEEPALIVE_PID" 2>/dev/null' EXIT
    fi

    # 1 つ失敗しても残りは走らせ、最後にまとめて失敗を返す
    local layer script failed=()
    for layer in $LAYERS; do
        for script in "$layer/init/"*.sh; do
            [ -e "$script" ] || continue
            echo "==> ${script/#"$HOME"/\~}"
            (cd "$DOTPATH" && bash "$script") || failed+=("${script/#"$HOME"/\~}")
        done
    done
    if [ "${#failed[@]}" -gt 0 ]; then
        printf 'failed: %s\n' "${failed[@]}" >&2
        return 1
    fi
}

main() {
    local cmd=${1:-}
    shift || true
    ROLES=${*:-$(default_roles)}
    local role
    for role in $ROLES; do
        case "$role" in
            client|devhost) ;;
            *) echo "unknown role: $role (client, devhost)" >&2; exit 1 ;;
        esac
    done
    PLATFORMS=$(platforms)
    LAYERS=$(layers)

    case "$cmd" in
        deploy) cmd_deploy ;;
        check) cmd_check ;;
        init) cmd_init ;;
        list) cmd_list ;;
        *) echo "usage: $0 <deploy|check|init|list> [role...]" >&2; exit 1 ;;
    esac
}

main "$@"
