
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

" basic
call s:source_config('basic.vim')
call s:source_config('apperance.vim')
call s:source_config('bundle.vim')
call s:source_config('colors.vim')
call s:source_config('encoding.vim')
call s:source_config('indent.vim')
call s:source_config('plugins.vim')
call s:source_config('quickfix.vim')
call s:source_config('search.vim')
call s:source_config('statusline.vim')


"set runtimepath+=~/.vim
"runtime! conf.d/*.vim

""マシン固有の設定.vimrc.localに記載
if filereadable(expand('$HOME/.vimrc.local'))
  source $HOME/.vimrc.local
endif

