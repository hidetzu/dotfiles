if &compatible
  set nocompatible
endif

" プラグイン管理ディレクトリ
let s:dein_path = expand('~/.vim/bundle/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim'

" deinなかったらcloneでもってくる
if !isdirectory(s:dein_repo_path)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
endif

execute 'set runtimepath^=' . s:dein_repo_path

" let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = 1

" 設定開始
call dein#begin(s:dein_path)
  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく

  let g:vim_config_dir    = expand('~/.vim/conf.d')
  let s:toml      = g:vim_config_dir . '/plugins.toml'
  let s:lazy_toml = g:vim_config_dir . '/plugins-lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
"  call dein#load_toml(s:lazy_toml, {'lazy': 1})
call dein#end()

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

