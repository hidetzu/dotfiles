
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

scriptencoding utf-8
set encoding=utf-8

set nocompatible
filetype off

"NeoBundleで管理するプラグインを読み込む
source $HOME/.vim/config/bundle.vimrc

"基本設定
source $HOME/.vim/config/basic.vimrc

"表示設定
source $HOME/.vim/config/apperance.vimrc

"検索関連
source $HOME/.vim/config/search.vimrc

"カラー設定
source $HOME/.vim/config/colors.vimrc

" プラグインの設定
source $HOME/.vim/config/plugins.vimrc

"エンコーディング関連
source $HOME/.vim/config/encoding.vimrc

"インデント設定
source $HOME/.vim/config/indent.vimrc

"マシン固有の設定.vimrc.localに記載
if filereadable(expand('$HOME/.vimrc.local'))
  source $HOME/.vimrc.local
endif
