
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

scriptencoding utf-8
set encoding=utf-8

set nocompatible
filetype off

let s:windows = has('win32') || has('win64')
let s:linux   = has('unix')

function! IsWindows()
  return s:windows
endfunction

function! IsLinux()
  return s:linux
endfunction

function! s:source_config(path)
  execute 'source' fnameescape(expand('~/.vim/conf.d/' . a:path))
endfunction

set path+=$HOME/.vim/conf.d/
let s:configs=[
      \ 'basic.vim',
      \ 'apperance.vim',
      \ 'bundle.vim',
      \ 'colors.vim',
      \ 'encoding.vim',
      \ 'indent.vim',
      \ 'plugins.vim',
      \ 'quickfix.vim',
      \ 'search.vim',
      \ 'statusline.vim',
      \]
for s:config in s:configs
  call s:source_config(s:config)
endfor


"set runtimepath+=~/.vim
"runtime! conf.d/*.vim

""マシン固有の設定.vimrc.localに記載
if filereadable(expand('$HOME/.vimrc.local'))
  source $HOME/.vimrc.local
endif

