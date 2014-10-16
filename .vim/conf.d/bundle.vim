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
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite-build.git'


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

"ステータスライン
NeoBundle 'itchyny/lightline.vim'

"カラースキーマ
NeoBundle 'nanotech/jellybeans.vim'
call neobundle#end()

NeoBundleCheck

