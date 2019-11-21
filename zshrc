NPM_PACKAGES="${HOME}/.npm/node_modules"
ZSH_THEME="lambda-gitster"
DEFAULT_USER=haletsky
COMPLETION_WAITING_DOTS="true"
plugins=(git npm npx node docker vagrant)

export GOPATH=/home/haletsky/go
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$HOME/bin:/usr/local/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$NPM_PACKAGES/bin
export ZSH=/home/haletsky/.oh-my-zsh
export EDITOR='nvim'

alias diary='nvim +VimwikiIndex +set\ laststatus=0'
alias f='ranger'
alias e='nvim'
alias icat="kitty +kitten icat"
alias xclip="wl-copy"

unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

killall () {
  kill -9 $(pgrep -d " " $1)
}

source $ZSH/oh-my-zsh.sh
