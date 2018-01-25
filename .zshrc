export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH=/home/mustard/.oh-my-zsh
export TERM="xterm-256color"

# ZSH_THEME="bira"
ZSH_THEME="lambda-gitster"
DEFAULT_USER=mustard
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git npm node docker vagrant)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

alias diary='nvim +VimwikiIndex +set\ laststatus=0'
alias f='ranger'
