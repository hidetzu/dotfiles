"--------------------------------
" 文字コード
"--------------------------------
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
set fileformat=unix
set fileformats=unix,dos,mac


command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>

command! -bang -complete=file -nargs=? Unix
\ edit<bang> ++fileformat=unix <args>
command! -bang -complete=file -nargs=? Dos
\ edit<bang> ++fileformat=dos <args>
