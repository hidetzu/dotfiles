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
set -o vi

# set term colors
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
  export TERM='xterm-256color'
else
  export TERM='xterm-color'
fi

# simple_clipboard
alias bfwrite="cat > .simple_clipboard"
alias bfcat="cat ~/.simple_clipboard"

if [ -e ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi

#################
#ssh alias
alias ssh-aws-vr-dev="ssh -i ~/.ssh/2501VR-01.ppk ec2-user@ec2-52-196-134-110.ap-northeast-1.compute.amazonaws.com"
alias ssh-aws-vr-dev2="ssh -i ~/.ssh/2501VR-01.ppk ec2-user@ec2-54-250-165-116.ap-northeast-1.compute.amazonaws.com"
alias ssh-aws-redmine-dev="ssh -i ~/.ssh/2501VR-01.ppk bitnami@ec2-13-113-113-148.ap-northeast-1.compute.amazonaws.com"

alias ssh-aws-vr-olddev="ssh -i ~/.ssh/2501dev01.ppk centos@nginx.2501world.com"
alias ssh-aws-vr-olddev2="ssh -i ~/.ssh/2501dev01.ppk centos@nginx2.2501world.com"

