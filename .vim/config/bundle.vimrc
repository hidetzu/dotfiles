"-------------------------------
" NeoBundleで管理するプラグイン
"-------------------------------
"
"vim起動時のみruntimepathにneobundle.vimを追加
if has('vim_starting')
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

"neobundle.vimの初期化
call neobundle#begin(expand('~/.vim/bundle/'))

"neobundle.vimを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'majutsushi/tagbar'
NeoBundle has('lua') ? 'Shougo/neocomplete.vim' : 'Shougo/neocomplcache.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'The-NERD-tree'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'nathanaelkane/vim-indent-guides'

NeoBundle 'scrooloose/syntastic'

"ステータスライン
NeoBundle 'itchyny/lightline.vim'

"カラースキーマ
NeoBundle 'nanotech/jellybeans.vim'
call neobundle#end()

NeoBundleCheck

