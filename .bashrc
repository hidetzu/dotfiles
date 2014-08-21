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

# set term colors
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

if [ -e ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi
