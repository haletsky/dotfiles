export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=/home/mustard/.oh-my-zsh
export TERM="xterm-256color"
export EDITOR='nvim'

ZSH_THEME="lambda-gitster"
DEFAULT_USER=
COMPLETION_WAITING_DOTS="true"
plugins=(git npm node docker vagrant)

alias diary='nvim +VimwikiIndex +set\ laststatus=0'
alias f='ranger'
alias e='nvim'
alias g='git'

source $ZSH/oh-my-zsh.sh
