NPM_PACKAGES="${HOME}/.npm/node_modules"
ZSH_THEME="lambda-gitster"
ZSH_COLORIZE_TOOL=chroma
DEFAULT_USER=haletsky
COMPLETION_WAITING_DOTS="true"
plugins=(
  colored-man-pages
  colorize
  docker
  docker-compose
  git
  golang
  kubectl
  node
  npm
  npx
  redis-cli
  screen
  timer
  vagrant
)

export GOPATH=/home/haletsky/go
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$NPM_PACKAGES/bin
export ZSH=/home/haletsky/.oh-my-zsh
export EDITOR='nvim'

alias diary='nvim +VimwikiIndex +set\ laststatus=0'
alias f='ranger'
alias e='nvim'
alias icat="kitty +kitten icat"
alias xclip="wl-copy"
alias btop="bashtop"

unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

killall () {
  kill -9 $(pgrep -d " " $1)
}

source $ZSH/oh-my-zsh.sh
source $HOME/.aws-creds.sh
