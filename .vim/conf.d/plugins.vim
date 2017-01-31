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

""tagbar {{{
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
  let g:tagbar_type_make = {
              \ 'kinds':[
                  \ 'm:macros',
                  \ 't:targets'
              \ ]
              \}
  let g:tagbar_type_markdown = {
      \ 'ctagstype' : 'markdown',
      \ 'kinds' : [
          \ 'h:Heading_L1',
          \ 'i:Heading_L2',
          \ 'k:Heading_L3'
      \ ]
      \ }
endif
""}}}

""{{{ The-NERD-tree
if neobundle#is_installed('The-NERD-tree')
  " 隠しファイルをデフォルトで表示させる
  let NERDTreeShowHidden = 1
  " デフォルトでツリーを表示させる
  "autocmd VimEnter * execute 'NERDTree'
  "nnoremap <silent><f2> :NERDTreeToggle<CR>

  " 無視するファイルを設定する
  let g:NERDTreeIgnore=['\.git$', '\.svn$', '\.bak$', '\.swp$', '\~$']
  " +|`などを使ってツリー表示をするか
  " 0 : 綺麗に見せる
  " 1 : +|`などを使わない
  let g:NERDTreeDirArrows=0

  "NERDTreeのウィンドウだけの場合には終了
  autocmd bufenter * if (winnr('$') == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | quit | endif
endif
""}}}

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


if neobundle#is_installed('vim-indent-guides')
  " vim-indent-guides
  " Vim 起動時 vim-indent-guides を自動起動
  let g:indent_guides_enable_on_vim_startup=1
  " ガイドをスタートするインデントの量
  let g:indent_guides_start_level=2
  " 自動カラー無効
  let g:indent_guides_auto_colors=0
  " 奇数番目のインデントの色
"  autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=110
  " 偶数番目のインデントの色
"  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=140
  " ハイライト色の変化の幅
  let g:indent_quides_color_change_percent = 30
  " ガイドの幅
  let g:indent_guides_guide_size = 1
endif

"" quickrun {{
if neobundle#is_installed("vim-quickrun")
  nnoremap <silent> <Leader>r :<C-u>QuickRun<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
  
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  " vimproc を使って非同期に実行し，結果を quickfix に出力する
  let g:quickrun_config = {
              \ '_': {
              \   "hook/close_unite_quickfix/enable_hook_loaded" : 1,
              \   "hook/unite_quickfix/enable_failure" : 1,
              \   "hook/close_quickfix/enable_exit" : 1,
              \   "hook/close_buffer/enable_failure" : 1,
              \   "hook/close_buffer/enable_empty_data" : 1,
              \   "outputter" : "multi:buffer:quickfix",
              \   "hook/shabadoubi_touch_henshin/enable" : 1,
              \   "hook/shabadoubi_touch_henshin/wait" : 20,
              \   "outputter/buffer/split" : "",
              \   "outputter/buffer/into" : 1,
              \   "outputter/buffer/running_mark" : "",
              \   "runner" : "vimproc",
              \   "runner/vimproc/updatetime" : 40,
              \   },
              \ 'c' : {
              \   'command' : 'gcc',
              \   'cmdopt'  : '-Wall -Wextra',
              \   'outputter' : 'quickfix',
              \   'runner' : 'vimproc'
              \   },
              \ 'make' : {
              \   'command': 'make',
              \   'outputter' : 'quickfix',
              \   'runner' : 'vimproc'
              \   },
              \ 'sed': {},
              \ 'sh': {},
              \ 'vim': {
              \   'command': ':source',
              \   'exec': '%C %s',
              \   'hook/eval/template': "echo %s",
              \   'runner': 'vimscript',
              \   },
              \ }
endif
""}}

"" syntastic {{{
if neobundle#is_installed('syntastic')
  augroup AutoSyntastic
      autocmd!
        autocmd BufWritePost *.c,*.cpp call s:syntastic()
      augroup END
      function! s:syntastic()
        SyntasticCheck
        call lightline#update()
      endfunction
    endif
""}}}

"" vim-watchdogs {{{
if neobundle#is_installed('vim-watchdogs')

"  let g:quickrun_config = {
"              \ 'watchdogs_checker/_': {
"              \     'outputter/quickfix/open_cmd' : '',
"              \   },
"              \}
"  call watchdogs#setup(g:quickrun_config)
  augroup Watchdogs
      autocmd!
      autocmd BufWritePost *.c,*.cpp WatchdogsRun
  augroup END


endif
""}}}

"" lightline.vim {{{
if neobundle#is_installed('lightline.vim')
  let g:lightline = {
        \ 'colorscheme': 'landscape',
        \ 'active': {
        \ 'left': [
        \   ['mode', 'paste'],
        \   [ 'bufnum', 'modified', 'readonly', 'help'],
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
        \   'bufnum': "[%n]",
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
endif
""}}}


"" unite.vim {{{
if neobundle#is_installed('unite.vim')
   " The prefix key.
  nnoremap    [unite]   <Nop>
  nmap    <Leader>f [unite]

 " history/yank有効
  let g:unite_source_history_yank_enable = 1 
 
  " unite.vim keymap
  nnoremap [unite]u  :<C-u>Unite-no-split<Space>
  nnoremap <silent> [unite]f :<C-u>Unite<Space> -buffer-name=files file<CR>
  nnoremap <silent> [unite]m :<C-u>Unite<Space> -buffer-name=files file_mru<CR>
  nnoremap <silent> [unite]b :<C-u>Unite<Space> -buffer-name=buffer buffer<CR>

  nnoremap <silent> [unite]g :<C-u>Unite<Space>grep -buffer-name=grep<CR>
  nnoremap <silent> [unite]gn :<C-u>Unite<Space>grep -buffer-name=grep -no-quit<CR>
  nnoremap <silent> [unite]gc :<C-u>UniteWithCursorWord -no-quit line<CR>

  nnoremap <silent> [unite]w :<C-u>Unite<Space> -buffer-name=window window<CR>
  nnoremap <silent> [unite]hy :<C-u>Unite<Space> -buffer-name=register history/yank<CR>

  nnoremap <silent> [unite]a :<C-u>Unite<Space>buffer file file_mru bookmark<CR>


  nnoremap <silent> [unite]r :<C-u>Unite<Space>-buffer-name=register register<CR>
  nnoremap <silent> ,vr :UniteResume<CR>
   
  " vinarise
  let g:vinarise_enable_auto_detect = 1
   

  " unite-build map
  nnoremap <silent> ,vb :Unite build<CR>
  nnoremap <silent> ,vcb :Unite build:!<CR>
  nnoremap <silent> ,vch :UniteBuildClearHighlight<CR>

  "menu
  let g:unite_source_menu_menus = {
  \   "shortcut" : {
  \    "description" : "unite-shortcut",
  \    "command_candidates" : [
  \       ["edit vimrc", "edit $MYVIMRC"],
  \       ["edit vim_config", "UniteWithInput file -no-quit -input=$HOME/.vim/conf.d/ -no-here"],
  \       ["edit gvimrc", "edit $MYGVIMRC"],
  \       ["load vimrc", "so  $MYVIMRC"],
  \       ["load gvimrc", "so $MYGVIMRC"],
  \       ["unite-file_mru", "Unite file_mru"],
  \       ["Unite Beautiful Attack", "Unite -auto-preview colorscheme"],
  \       ["unite-output:message", "Unite output:message"],
  \      ],
  \   },
  \
  \   "toggle_options" : {
  \    "description" : "unite-toggle-options",
  \    "command_candidates" : [
  \       ["tagbar",  "TagbarToggle"],
  \       ["nerdtree", "NERDTreeToggle"],
  \       ["syntastic ", "SyntasticToggleMode"],
  \     ],
  \   },
  \   "encoding" : {
  \    "description" : "open with a specific character set.",
  \    "command_candidates" : [
  \       ["utf-8", "Utf8"], 
  \       ["iso2022jp", "Iso2022jp"], 
  \       ["cp932", "Cp932"], 
  \     ],
  \   },
  \   "fileformat" : {
  \    "description" : "change file format option",
  \    "command_candidates" : [
  \       ["unix", "Unix"], 
  \       ["dos", "Dos"], 
  \    ],
  \   },
  \}

  autocmd FileType unite call s:unite_my_settings()

  function! s:unite_my_settings()

    "ESCでuniteを終了
    nmap <buffer> <ESC> <Plug>(unite_exit)
    "入力モードのときjjでノーマルモードに移動
    imap <buffer> jj <Plug>(unite_insert_leave)
    "入力モードのときctrl+wでバックスラッシュも削除
    imap <buffer> <C-w> <Plug>(unite_delete_backward_path)

    let l:unite = unite#get_current_unite()
    echon l:unite.buffer_name
    if l:unite.buffer_name ==# 'files'
      nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
      inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
      " ウィンドウを縦に分割して開く
      nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
      inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')

      "ctrl+oでその場所に開く
      nnoremap <silent><buffer><expr> <C-o> unite#do_action('open')
      inoremap <silent><buffer><expr> <C-o> unite#do_action('open')
    elseif l:unite.buffer_name ==# 'grep'
     nnoremap <silent><buffer><expr> r unite#do_action('replace') 
    end
  endfunction

endif
""}}}

"" neomru.vim {{{
if neobundle#is_installed('neomru.vim')
  let g:neomru#time_format="(%Y/%m/%d %H:%M:%S) "
endif
""}}}

