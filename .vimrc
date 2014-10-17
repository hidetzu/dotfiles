
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

scriptencoding utf-8
set encoding=utf-8

set nocompatible
filetype off

set runtimepath+=~/.vim
runtime! conf.d/*.vim

""マシン固有の設定.vimrc.localに記載
if filereadable(expand('$HOME/.vimrc.local'))
  source $HOME/.vimrc.local
endif

