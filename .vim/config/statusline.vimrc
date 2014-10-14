"--------------------------------
" ステータス表示
"--------------------------------
set laststatus=2

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

