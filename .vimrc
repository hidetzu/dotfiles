scriptencoding utf-8
set encoding=utf-8

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
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'The-NERD-tree'

NeoBundle 'vim-jp/vimdoc-ja.git'

"カラースキーマ
NeoBundle 'nanotech/jellybeans.vim'

""" 基本設定
" マシン固有の設定.vimrc.localに記載
if filereadable(expand('$HOME/.vimrc.local'))
  source $HOME/.vimrc.local
endif

NeoBundleCheck

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


"--------------------------------
" 検索
"--------------------------------
set incsearch
set hlsearch

set history=1000
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
set statusline+=\       "空白スペース
set statusline+=%{fugitive#statusline()}  "Git情報
set statusline+=%=      "左と右の区別
set statusline+=%1l     "何行目にカーソルがあるか
set statusline+=/
set statusline+=%L      "バッファの総行数
set statusline+=,
set statusline+=%c      "何列目にカーソルがあるか
set statusline+=\ \
set statusline+=%P      "ファイル内の%での位置

set t_Co=256
syntax on
colorscheme jellybeans

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
  highlight CursorLine ctermbg=232  | highlight CursorColumn ctermbg=232
  highlight CursorColumn  ctermbg=232  | highlight CursorColumn ctermbg=232

  function! s:activeCursorlineColum()
    let l:current_buffer_name =bufname("%")
    let l:ignore_buffer_name_list=[
          \  "__Tagbar__",
          \  "NERD_tree_",
          \]

    for item in l:ignore_buffer_name_list
      if match(l:current_buffer_name, item) == -1
        continue
      endif
      return
    endfor

    setlocal cursorline! cursorcolumn!
  endfunction
  autocmd VimEnter,BufWinEnter,WinEnter * call s:activeCursorlineColum()
  autocmd WinLeave * setlocal nocursorline  nocursorcolumn
  command! -nargs=0 -bar CursorLineToggle :setlocal cursorline! cursorcolumn!
augroup END

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
  nnoremap <Space>, :so $MYVIMRC<CR>
  nnoremap <Space>. :sp $MYVIMRC<CR>
augroup END

augroup vim_help
  autocmd FileType vim setlocal keywordprg=:help
augroup END

function! IncludeGuard()
  try
    let filepath = expand('%')
    let extension = fnamemodify(filepath, ':e')
    let ismatch = match(extension, "h")
    if ismatch == -1
      throw "Extension Error"
    endif

    let name = toupper(fnamemodify(filepath,':t'))
    let included = '__'.substitute(name,'\.','_','g').'_INCLUDED__'

    let res = {
                \ "head": '#ifndef '.included."\n#define ".included."\n\n",
                \ 'foot': "\n".'#endif /* '.included." */"
                \}
    silent! execute '1s/^/\=res.head/'
    silent! execute '$s/$/\=res.foot/'

  catch /Extension Error/
    echom "Extension Error"
  endtry
endfunction

augroup pmenu_color
  hi Pmenu        ctermbg=0      ctermfg=226   "ノーマルアイテム
  hi PmenuSel     ctermbg=211    ctermfg=0     "選択しているアイテム
  hi PmenuSbar    ctermbg=0                    "スクロールバー
  hi PmenuThumb   ctermfg=255                  "スクロールバーのレバー
augroup END


"-------------------------------
" プラグインの設定
"-------------------------------
if neobundle#is_installed('neocomplete')
    " neocomplete用設定
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_ignore_case = 1
    let g:neocomplete#enable_smart_case = 1
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns._ = '\h\w*'
elseif neobundle#is_installed('neocomplcache.vim')
    " neocomplcache用設定
    let g:acp_enableAtStartup = 0
    " 起動時に有効化
    let g:neocomplcache_enable_at_startup = 1
    " 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplcache_enable_smart_case = 1
    " _(アンダースコア)区切りの補完を有効化
    let g:neocomplcache_enable_underbar_completion = 1
    let g:neocomplcache_enable_camel_case_completion  =  1
    " ポップアップメニューで表示される候補の数
    let g:neocomplcache_max_list = 20
    " シンタックスをキャッシュするときの最小文字長
    let g:neocomplcache_min_syntax_length = 3
    " ディクショナリ定義
    let g:neocomplcache_dictionary_filetype_lists = {
          \ 'default' : '',
          \ }
    if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " 前回行われた補完をキャンセルします
    inoremap <expr><C-g> neocomplcache#undo_completion()
    " 補完候補のなかから、共通する部分を補完します
    inoremap <expr><C-l> neocomplcache#complete_common_string()
    " 改行で補完ウィンドウを閉じる
    inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
    "tabで補完候補の選択を行う
    inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
    " <C-h>や<BS>を押したときに確実にポップアップを削除します
    inoremap <expr><C-h> neocomplcache#smart_close_popup() . "\<C-h>"
    " 現在選択している候補を確定します
    inoremap <expr><C-y> neocomplcache#close_popup()
    " 現在選択している候補をキャンセルし、ポップアップを閉じます
    inoremap <expr><C-e> neocomplcache#cancel_popup()
endif

if neobundle#is_installed('tagbar')
  nmap <F8> :TagbarToggle<CR>
  "tagbarでcssもサポートする
  let g:tagbar_type_css = {
        \ 'ctagstype' : 'Css',
        \ 'kinds' : [
        \ 'c:classes',
        \ 's:selectors',
        \ 'i:identities'
        \ ]
        \ }
endif

if neobundle#is_installed('The-NERD-tree')
  " 隠しファイルをデフォルトで表示させる
  let NERDTreeShowHidden = 1
  " デフォルトでツリーを表示させる
  autocmd VimEnter * execute 'NERDTree'
  nnoremap <f2> :NERDTreeToggle<CR>

  " 無視するファイルを設定する
  let g:NERDTreeIgnore=['\.git$', '\.svn$', '\.bak$']
  " +|`などを使ってツリー表示をするか
  " 0 : 綺麗に見せる
  " 1 : +|`などを使わない
  let g:NERDTreeDirArrows=0

  "Quickfixのウィンドウだけの場合には終了
  function! s:NERDTree_Exit_OnlyWindow()
    if winnr('$') == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary"
      quit
    endif
  endfunction
  autocmd bufenter * call s:NERDTree_Exit_OnlyWindow()
endif

if neobundle#is_installed('neosnippet')
  " Enable snipMate compatibility feature.
  let g:neosnippet#enable_snipmate_compatibility = 1
  " Tell Neosnippet about the other snippets
  let g:neosnippet#snippets_directory=''

  " Plugin key-mappings.
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)
  " SuperTab like snippets behavior.
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)"
        \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)"
        \: "\<TAB>"


  " For snippet_complete marker.
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif
endif


set pastetoggle=<f5>
vmap X y/<C-R>"<CR>


filetype plugin indent on

augroup vimrc_filetype
  autocmd FileType sh         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType lua        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType snip       setlocal noexpandtab
augroup END
