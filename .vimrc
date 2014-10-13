
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

scriptencoding utf-8
set encoding=utf-8

set nocompatible
filetype off

"vim起動時のみruntimepathにneobundle.vimを追加
if has('vim_starting')
  set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

"neobundle.vimの初期化
call neobundle#begin(expand('~/.vim/bundle/'))

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
NeoBundle 'mattn/webapi-vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'nathanaelkane/vim-indent-guides'

NeoBundle 'scrooloose/syntastic'

"ステータスライン
NeoBundle 'itchyny/lightline.vim'

"カラースキーマ
NeoBundle 'nanotech/jellybeans.vim'
call neobundle#end()

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
"set diffopt=filler,vertical

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
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"tmuxからのコピー内容を読み出す
nnoremap <C-b> :read ~/.simple_clipboadr<CR>

"myautocmdグループのautocommandをすべて削除する
augroup myautocmd
  autocmd!
  autocmd VimEnter,WinEnter * match Error /\s\+$/
augroup END

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

"-------------------------------
" プラグインの設定
"-------------------------------
if neobundle#is_installed('neocomplete.vim')
  " neocomplete用設定
  let g:acp_enableAtStartup = 0
  " 起動時に有効化
  let g:neocomplete#enable_at_startup = 1

  " 補完時に大文字/小文字を無視するかどうか
  let g:neocomplete#enable_ignore_case = 0
  let g:neocomplete#enable_smart_case = 1

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  " ディクショナリ定義
  let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " 前回行われた補完をキャンセルします
  inoremap <expr><C-g> neocomplete#undo_completion()
  " 補完候補のなかから、共通する部分を補完します
  inoremap <expr><C-l> neocomplete#complete_common_string()
  " 改行で補完ウィンドウを閉じる
  inoremap <expr><CR> neocomplete#smart_close_popup() . "\<CR>"
  "tabで補完候補の選択を行う
  inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
  " <C-h>や<BS>を押したときに確実にポップアップを削除します
  inoremap <expr><C-h> neocomplete#smart_close_popup() . "\<C-h>"
  " 現在選択している候補を確定します
  inoremap <expr><C-y> neocomplete#close_popup()
  " 現在選択している候補をキャンセルし、ポップアップを閉じます
  inoremap <expr><C-e> neocomplete#cancel_popup()

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

  "NERDTreeのウィンドウだけの場合には終了
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
  let g:neosnippet#snippets_directory='$HOME/.vim/snippets/ $HOME/.vim/bundle/neosnippet-snippets/neosnippets/'

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


if neobundle#is_installed('jellybeans.vim')
  " 本当はこんな感じで設定できるはず
  let g:jellybeans_overrides = {
        \   'Pmenu' :        { 'ctermbg' : 'Black', 'ctermfg' : 'Yellow'},
        \   'PmenuSel' :     { 'ctermbg' : '211', 'ctermfg' : '0'},
        \   'PmenuSbar' :    { 'ctermbg' : '159'},
        \   'PmenuThumb' :   { 'ctermfg' : '255'},
        \}
  
  augroup pmenu_color
    autocmd!
    hi Pmenu        ctermbg=159    ctermfg=0     "ノーマルアイテム
    hi PmenuSel     ctermbg=211    ctermfg=0     "選択しているアイテム
    hi PmenuSbar    ctermbg=159                  "スクロールバー
    hi PmenuThumb   ctermfg=255                  "スクロールバーのレバー
  augroup END

endif

if neobundle#is_installed('vim-indent-guides')
  " vim-indent-guides
  " Vim 起動時 vim-indent-guides を自動起動
  let g:indent_guides_enable_on_vim_startup=1
  " ガイドをスタートするインデントの量
  let g:indent_guides_start_level=2
  " 自動カラー無効
  let g:indent_guides_auto_colors=0
  " 奇数番目のインデントの色
  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=110
  " 偶数番目のインデントの色
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=140
  " ハイライト色の変化の幅
  let g:indent_quides_color_change_percent = 30
  " ガイドの幅
  let g:indent_guides_guide_size = 1
end

if neobundle#is_installed('syntastic')
  augroup AutoSyntastic
      autocmd!
        autocmd BufWritePost *.c,*.cpp call s:syntastic()
      augroup END
      function! s:syntastic()
        SyntasticCheck
        call lightline#update()
      endfunction
end

if neobundle#is_installed('lightline.vim')
  let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'active': {
        \ 'left': [
        \   ['mode', 'paste'],
        \   ['bufn', 'modified', 'readonly', 'help'],
        \   ['filename', 'filetype', 'fileencoding','fileformat'],
        \   ['fugitive'],
        \  ],
        \ 'right': [
        \   [ 'syntastic'],
        \   [ 'totalline', 'lineinfo' ],
        \   [ 'percent' ],
        \  ],
        \ },
        \ 'component': {
        \   'help': '%h',
        \   'filetype': '%y',
        \   'fugitive': '%{fugitive#statusline()}',
        \   'totalline': '%L',
        \ },
        \ 'component_expand': {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \ },
        \ 'component_type': {
        \   'syntastic': 'error',
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '|', 'right': '|' }
        \ }
else
  "ステータスライン表示文字列
  set statusline=%<       "行が長すぎるときに切り詰める位置
  set statusline+=[%n]    "バッファ番号
  set statusline+=%m      "修正フラグ
  set statusline+=%r      "読み込み専用フラグ
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
end

vmap X y/<C-R>"<CR>


filetype plugin indent on

augroup vimrc_filetype
  "vimrc_filetypeグループのautocommandをすべて削除する
  autocmd!
  autocmd FileType sh         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType lua        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType snip       setlocal noexpandtab
augroup END
