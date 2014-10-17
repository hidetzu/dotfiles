"-------------------------------------------------------------------------------
"" 表示 Apperance
"-------------------------------------------------------------------------------
set number
set title
set nowrap
set showcmd
"set diffopt=filler,vertical

" 全角記号の表示がおかしくなる問題に対する対策
set ambiwidth =double
set pastetoggle=<f5>

"タブ、空白、改行の可視化
set list
set listchars=tab:>-

"全角スペースをハイライト表示
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif

" アクティブウィンドウに限りカーソル行(列)を強調する
augroup vimrc_set_cursorline_only_active_window
  autocmd!
  highlight CursorLine ctermbg=232  | highlight CursorColumn ctermbg=232
  highlight CursorColumn  ctermbg=232  | highlight CursorColumn ctermbg=232

  function! s:activeCursorlineColum()
    let l:ignore_buffer_type_list=[
      \ "nofile",
      \ "quickfix",
      \ "help",
      \]

    let l:current_buftype=getbufvar(winbufnr(0), '&buftype')
    if index(l:ignore_buffer_type_list, l:current_buftype) >= 0
      return
    endif

    setlocal cursorline! cursorcolumn!
  endfunction
  autocmd VimEnter,BufWinEnter,WinEnter * call s:activeCursorlineColum()
  autocmd WinLeave * setlocal nocursorline  nocursorcolumn
  command! -nargs=0 -bar CursorLineToggle :setlocal cursorline! cursorcolumn!
augroup END

"myautocmdグループのautocommandをすべて削除する
augroup myautocmd
  autocmd!
"  autocmd VimEnter,WinEnter * match Error /\s\+$/
augroup END
