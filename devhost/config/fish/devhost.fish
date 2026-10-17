# devhost の役割でだけ読む開発ツールの設定（config.fish から source される）

### Golang ###
set -x GOPATH $HOME/go
fish_add_path -g $GOPATH/bin

### mise (version manager) ###
if type -q mise
    mise activate fish | source
end
