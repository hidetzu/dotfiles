set -x EDITOR nvim
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x LANG ja_JP.UTF-8

### キー: vi モードと fzf (ctrl-t / ctrl-r / alt-c) ###
set -g fish_key_bindings fish_vi_key_bindings
# キーを張り直すたびに呼ばれるので、vi モードの後に fzf のキーを足す
function fish_user_key_bindings
    if type -q fzf
        fzf --fish | source
    end
end

fish_add_path -g $HOME/.local/bin

### 開発ツール (Go / mise)。devhost の役割で入る ###
if test -f ~/.config/fish/devhost.fish
    source ~/.config/fish/devhost.fish
end

### Starship prompt ###
if type -q starship
    starship init fish | source
end
