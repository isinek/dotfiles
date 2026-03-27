# shellcheck shell=bash

alias ls='ls --color=auto'
alias ll='ls -alh'
alias less='less --RAW-CONTROL-CHARS'
alias grep='grep --color=auto'

alias ..='cd ../'
alias ...='cd ../../'

alias gitk='git log --all --graph --decorate --oneline'
alias gd='git diff --histogram'

alias nv='nvim'

mkcd () {
  mkdir -p "$1" && cd "$1" || return
}
