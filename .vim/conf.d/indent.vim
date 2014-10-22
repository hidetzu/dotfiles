"------------------------------------------------
" インデント
"------------------------------------------------

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用する
  filetype indent on

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
endif
