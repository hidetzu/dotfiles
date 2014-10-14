"------------------------------------------------
" Colors
"------------------------------------------------

set t_Co=256
syntax on

if neobundle#is_installed('jellybeans.vim')
  colorscheme jellybeans

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
