set nocompatible

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



"--------------------------------
" システム設定
"--------------------------------
" バックアップ/スワップファイルを作成する/しない
set nobackup
"set backspace=

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

"-------------------------------
" プラグインの設定
"-------------------------------

let g:neocomplcache_enable_at_startup = 1


set pastetoggle=<f5>
nmap <F8> :TagbarToggle<CR>
vmap X y/<C-R>"<CR>

runtime macros/matchit.vim
