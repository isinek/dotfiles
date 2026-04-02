# shellcheck shell=bash

alias eza='eza --icons=auto'
alias ll='eza -al --git --icons=auto'
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
