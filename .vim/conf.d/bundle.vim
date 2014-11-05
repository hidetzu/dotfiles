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
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }

NeoBundle 'Shougo/neomru.vim',
      \{ 'depends' : 'Shougo/unite.vim'}
NeoBundle 'Shougo/unite-build.git'
NeoBundle 'tsukkee/unite-tag.git'

" qfreplace : Quickfixを利用した一斉置換
NeoBundleLazy 'thinca/vim-qfreplace', {
  \ 'autoload' : {
  \ 'filetypes' : ['unite', 'quickfix'],
  \ }
\ }

"NeoBundleLazy 'alpaca-tc/alpaca_tags', {
"              \    'depends': ['Shougo/vimproc'],
"              \    'autoload' : {
"              \       'commands' : [
"              \          { 'name' : 'AlpacaTagsBundle', 'complete': 'customlist,alpaca_tags#complete_source' },
"              \          { 'name' : 'AlpacaTagsUpdate', 'complete': 'customlist,alpaca_tags#complete_source' },
"              \          'AlpacaTagsSet', 'AlpacaTagsCleanCache', 'AlpacaTagsEnable', 'AlpacaTagsDisable', 'AlpacaTagsKillProcess', 'AlpacaTagsProcessStatus',
"              \       ],
"              \    }
"              \ }

NeoBundle 'scrooloose/syntastic'
"NeoBundle "osyo-manga/vim-watchdogs"

"ステータスライン
NeoBundle 'itchyny/lightline.vim'

"カラースキーマ
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'itchyny/landscape.vim'

call neobundle#end()

NeoBundleCheck

