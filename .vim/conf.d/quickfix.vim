"--------------------------------
" quickfixウィンドウ設定
"--------------------------------

augroup quickfixopen
  autocmd!
  "grep makeは検索結果を常の表示する
  autocmd QuickFixCmdPost make cwindow

  "Quickfixのウィンドウだけの場合には終了
  autocmd WinEnter * if (winnr('$') == 1 && getbufvar(winbufnr(0), '&buftype') == 'quickfix' ) | quit | endif

  command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
  function! QuickfixFilenames()
    let buffer_numbers={}
    for quickfix_item in getqflist()
      let buffer_numbers[quickfix_item['bufnr']]=bufname(quickfix_item['bufnr'])
    endfor
    return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
  endfunction

augroup END
