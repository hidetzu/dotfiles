"--------------------------------
" 検索
"--------------------------------
set wrapscan
set incsearch
set hlsearch

set history=1000

nmap <Esc><Esc> :nohls<CR><Esc>
vmap X y/<C-R>"<CR>


augroup search_grep
  set grepprg=grep\ -rnIH\ --exclude-dir=.svn\ --exclude-dir=.git
  autocmd QuickfixCmdPost *grep* cwindow

  " grep の書式を挿入
  nnoremap <expr> <Space>g ':vimgrep /\<' . expand('<cword>') . '\>/j **/*.' . expand('%:e')
  nnoremap <expr> <Space>G ':sil grep! ' . expand('<cword>') . ' *'
augroup END

