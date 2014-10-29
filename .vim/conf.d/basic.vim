"--------------------------------
" 基本設定
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
set vb t_vb=                             "ビープ音なし

" Set English mode
if IsWindows()
  lan mes en
elseif IsLinux()
  lan mes C
endif


let mapleader = ","                    " キーマップリーダー

"------------------------------
" キーマップ
"-------------------------------
nmap <silent> <Esc><Esc> :nohls<CR><Esc>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"tmuxからのコピー内容を読み出す
nnoremap <C-b> :read ~/.simple_clipboadr<CR>

"-------------------------------
" コマンド
"-------------------------------

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
