set nocompatible
filetype off

"vim起動時のみruntimepathにneobundle.vimを追加
if has('vim_starting')
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

"neobundle.vimの初期化
call neobundle#rc(expand('$HOME/.vim/bundle'))

"neobundle.vimを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'

"-------------------------------
" NeoBundleで管理するプラグイン
"-------------------------------
NeoBundle 'majutsushi/tagbar'
NeoBundle has('lua') ? 'Shougo/neocomplete.vim' : 'Shougo/neocomplcache.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'The-NERD-tree'
NeoBundle 'nanotech/jellybeans.vim'

NeoBundleCheck

filetype plugin indent on

""" 基本設定
" マシン固有の設定.vimrc.localに記載
if filereadable(expand('$HOME/.vimrc.local'))
  source $HOME/.vimrc.local
endif


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
" タブの入力を空白文字に置き換える
set expandtab

"タブ、空白、改行の可視化
set list
"set listchars=tab:>.,trail:_,eol:↲,extends:>,precedes:<,nbsp:%
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


"--------------------------------
" 検索
"--------------------------------
set incsearch
set hlsearch

set history=200
set cindent


"--------------------------------
" 表示設定 
"--------------------------------
set number
set title
set nowrap
set showcmd
set laststatus=2

"ステータスライン表示文字列
set statusline=%<       "行が長すぎるときに切り詰める位置
set statusline+=[%n]    "バッファ番号
set statusline+=%m      "修正フラグ
set statusline+=%r      "読み込み専用フラグ
set statusline+=%h      "ヘルプビューウィンドウフラグ
set statusline+=%h      "ヘルプビューウィンドウフラグ
set statusline+=\       "空白スペース
set statusline+=%{&fenc}:"ファイルの文字コード
set statusline+=%{&fileformat} "ファイルの改行コード
set statusline+=\       "空白スペース
set statusline+=%y      "ファイル種別
set statusline+=\       "空白スペース
set statusline+=%F      "ファイル名
set statusline+=%=      "左と右の区別
set statusline+=%1l     "何行目にカーソルがあるか
set statusline+=/
set statusline+=%L      "バッファの総行数
set statusline+=,
set statusline+=%c      "何列目にカーソルがあるか
set statusline+=\ \ 
set statusline+=%P      "ファイル内の%での位置

"カラー表示
set t_Co=256
syntax on
"colorscheme wombat256
colorscheme jellybeans

"set cursorcolumn
"set cursorline
"nnoremap <Leader>c :<C-u>setlocal cursorline! cursorcolumn!<CR>

"--------------------------------
" 文字コード 
"--------------------------------
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
set fileformats=unix,dos,mac

"------------------------------
" キーマップ
"-------------------------------
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"vimrc_filetypeグループのautocommandをすべて削除する
augroup vimrc_filetype
  autocmd!
augroup END

augroup vimrc_filetype
  autocmd FileType sh         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
augroup END

"myautocmdグループのautocommandをすべて削除する
augroup myautocmd
  autocmd!
augroup END

augroup myautocmd
  autocmd VimEnter,WinEnter * match Error /\s\+$/
augroup END

" アクティブウィンドウに限りカーソル行(列)を強調する
augroup vimrc_set_cursorline_only_active_window
  autocmd!
  autocmd VimEnter,BufWinEnter,WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" インサートモードに入った時にカーソル行(列)の色を変更する
augroup vimrc_change_cursorline_color
  autocmd!
  " インサートモードに入った時にカーソル行の色をブルーグリーンにする
  autocmd InsertEnter * highlight CursorLine term=reverse | highlight CursorColumn term=reverse
  " インサートモードを抜けた時にカーソル行の色を黒に近いダークグレーにする
  autocmd InsertLeave * highlight CursorLine ctermbg=236  | highlight CursorColumn ctermbg=236
augroup END

"grep makeは検索結果を常の表示する
autocmd QuickFixCmdPost make,*grep* cwindow

"Quickfixのウィンドウだけの場合には終了
function s:QuickFix_Exit_OnlyWindow()
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

"-------------------------------
" プラグインの設定
"-------------------------------

let g:neocomplcache_enable_at_startup = 1

set pastetoggle=<f5>
nmap <F8> :TagbarToggle<CR>
vmap X y/<C-R>"<CR>
