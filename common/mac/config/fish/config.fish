### Homebrew ###
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

set -x XDG_CONFIG_HOME "$HOME/.config"
set -x LANG ja_JP.UTF-8
set -x EDITOR nvim

### キー: vi モードと fzf (ctrl-t / ctrl-r / alt-c) ###
set -g fish_key_bindings fish_vi_key_bindings
# キーを張り直すたびに呼ばれるので、vi モードの後に fzf のキーを足す
function fish_user_key_bindings
    if type -q fzf
        fzf --fish | source
    end
end

### 開発ツール (Go / mise)。devhost の役割で入る ###
if test -f ~/.config/fish/devhost.fish
    source ~/.config/fish/devhost.fish
end

fish_add_path -g $HOME/.local/bin

### Starship prompt
starship init fish | source
