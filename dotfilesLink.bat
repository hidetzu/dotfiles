rem  windows用のリンク生成スクリプト
rem  user\\dotfilesのような構成にあることを期待している

set dotfiles=dotfiles
set vim_dir=.vim

@echo off
cd ..

rem .vimディレクトリ作成
If  not exist %vim_dir% (
	mkdir %vim_dir%
)

rem .vimrcと.gvimrcはハードリンク
mklink /H  dotfiles\\.vimrc .vimrc
