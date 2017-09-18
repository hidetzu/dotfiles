"------------------------------------------------
" Colors
"------------------------------------------------

if dein#tap('jellybeans.vim')
  colorscheme jellybeans

"  let g:jellybeans_overrides = {
"        \   'Pmenu' :        { '256ctermbg' : 159, '256ctermfg' : 0},
"        \   'PmenuSel' :     { '256ctermbg' : 211, '256ctermfg' : 0},
"        \   'PmenuSbar' :    { '256ctermbg' : 159},
"        \   'PmenuThumb' :   { '256ctermfg' : 255},
"        \}
else 
  set  background=dark

  augroup pmenu_color
    autocmd!
    hi Pmenu        ctermbg=159    ctermfg=0     "ノーマルアイテム
    hi PmenuSel     ctermbg=211    ctermfg=0     "選択しているアイテム
    hi PmenuSbar    ctermbg=159                  "スクロールバー
    hi PmenuThumb   ctermfg=255                  "スクロールバーのレバー
  augroup END
endif

set t_Co=256
syntax on


