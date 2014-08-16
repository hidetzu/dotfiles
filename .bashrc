# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

if [ -x `which vim` ]; then
  alias vi='vim'
  alias view='vim -R'
fi


export EDITOR=vim

if [[ -e ~/.bashrc.local ]]; then
  source ~/.bashrc.local
fi
