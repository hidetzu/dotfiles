"--------------------------------
" システム設定
"--------------------------------
" バックアップ/スワップファイルを作成する/しない
set nobackup
" swpファイルを作成しない
set noswapfile
" backspaceキーの挙動を設定する
" indent : 行頭の空白の削除を許す
" eol : 改行の削除を許す
" start : 挿入モードの開始位置での削除を許す
set backspace=indent,eol,start
" 新しい行を直前の行と同じインデントにする
set autoindent
" Tab文字を画面上の見た目で何文字幅にするか設定
set tabstop=4
" cindentやautoindent時に挿入されるタブの幅
set shiftwidth=4
" タブの入力はタブのままにする。ファイルタイプごとに設定する。
set noexpandtab

"------------------------------
" キーマップ
"-------------------------------
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"tmuxからのコピー内容を読み出す
nnoremap <C-b> :read ~/.simple_clipboadr<CR>

" Quickfix
augroup quickfixopen
  autocmd!
  "grep makeは検索結果を常の表示する
  autocmd QuickFixCmdPost make,*grep* cwindow
augroup END

"Quickfixのウィンドウだけの場合には終了
function! s:QuickFix_Exit_OnlyWindow()
  if winnr('$') == 1
    if (getbufvar(winbufnr(0), '&buftype')) == 'quickfix'
      quit
    endif
  endif
endfunction
autocmd WinEnter * call s:QuickFix_Exit_OnlyWindow()

"-------------------------------
" コマンド
"-------------------------------
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers={}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']]=bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
command! -bar -bang -nargs=? -complete=file GScouter
\        echo Scouter(empty(<q-args>) ? $MYGVIMRC : expand(<q-args>), <bang>0)

augroup myvimrc
  autocmd!
  function! s:File_open(path)
    if bufexists(a:path)
      let l:winnr = bufwinnr(a:path)
      if l:winnr <= 0
        let l:winnr = 1
      endif
      execute l:winnr .'wincmd w'
    else
      execute 'split '.a:path
    endif
  endfunction

  nnoremap <silent> <Space>, :so $MYVIMRC<CR>
  nnoremap <silent> <Space>. :call <SID>File_open($MYVIMRC)<CR>
augroup END

augroup vim_help
  autocmd FileType vim setlocal keywordprg=:help
augroup END

function! IncludeGuard()
  try
    let l:filepath = expand('%')
    let l:extension = fnamemodify(l:filepath, ':e')
    if match(l:extension, "h") == -1
      throw "Extension Error"
    endif

    let l:name = toupper(fnamemodify(l:filepath,':t'))
    let l:included = '__'.substitute(l:name,'\.','_','g').'_INCLUDED__'

    let l:res = {
                \ "head": '#ifndef '.l:included."\n#define ".l:included."\n\n",
                \ 'foot': "\n".'#endif /* '.l:included." */"
                \}
    silent! execute '1s/^/\=l:res.head/'
    silent! execute '$s/$/\=l:res.foot/'

  catch /Extension Error/
    echom "Extension Error"
  endtry
endfunction
