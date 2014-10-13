#!/bin/sh

DOT_FILES=(
.bashrc
.tmux.conf
.vimrc
.vim
)

for file in ${DOT_FILES[@]}
do
  ln -sf $HOME/dotfiles/$file $HOME/$file
done

########################
# gitが1.7.10以降でないとinclude機能をサポートしていないため
# そのバージョン以下のものはシンボリックリンクを生成しない
git_version_array=("1" "7" "10")
git_currentversion_array=( `git --version | awk '{print $3}' | tr -s '.' ' ' ` )
git_include_use=0
for(( I = 0; I < ${#git_currentversion_array[@]}; ++I )) do
  check_value=`expr "${git_version_array[$I]}"`
  current_value=`expr "${git_currentversion_array[$I]}"`

  if [ $check_value -lt $current_value ]; then
    git_include_use=1
    break
  elif [ $check_value -eq $current_value ]; then
    git_include_use=1
    continue
  else
    git_include_use=0
    break
  fi
done

if [ $git_include_use -eq 1 ]; then
  ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
else
  echo ".gitconfig skiped "
fi

[ ! -d ~/.vim/bundle ] && mkdir -p ~/.vim/bundle && git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim && echo "you should run following command to setup plugins -> vim -c ':NeoBundleInstall'"
