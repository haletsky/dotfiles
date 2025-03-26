NPM_PACKAGES="${HOME}/.npm/node_modules"
ZSH_THEME="lambda-gitster"
ZSH=$HOME/.oh-my-zsh
ZSH_COLORIZE_TOOL=chroma
DEFAULT_USER=haletsky
COMPLETION_WAITING_DOTS="true"
plugins=(
  aws
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
export PATH=$PATH:/Applications/Docker.app/Contents/Resources/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/dotfiles/bin
export PATH=$PATH:$HOME/.npm/bin
export PATH="$PATH:/Users/bkhaletskyi/.dotnet/tools"
export EDITOR='nvim'
export DOCKER_CLI_HINTS=false

alias diary='nvim +VimwikiIndex +set\ laststatus=0'
alias f='ranger'
# alias nvim='/Users/bkhaletskyi/bin/nvim-macos/bin/nvim'
alias e='nvim'
alias eu='nvim +PlugUpdate'
alias icat="kitty +kitten icat"
alias xclip="wl-copy"
alias btop="bashtop"
alias tabtitle="kitty @ set-tab-title"
alias ssh="kitty +kitten ssh"
alias glog="git log --oneline --decorate --graph --format=\"%Cred%d%Creset %s\""

unset MANPATH # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

killall () {
  kill -9 $(pgrep -d " " $1)
}

# rgr - ripgrep replace (find and replace)
# $1  - string to find
# $2  - string to replace
# $3  - path in which to find and replace (optional)
rgr () {
    while IFS= read -r file; do
        sed -i '' -e "s/$1/$2/g" "$file"
    done <<< $(rg "$1" --files-with-matches "$3")
}

source $ZSH/oh-my-zsh.sh

autoload -Uz compinit
compinit
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
