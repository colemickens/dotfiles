# history
HISTSIZE=10000
HISTFILE=$HOME/.zsh_history
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# completions
autoload -Uz compinit
# load dircolors
eval $(dircolors -b)
# use dircolors in tab completions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# try to force load the gitstatus zsh plugin
# that matches the system's gitstatus binary:
source /run/current-system/sw/share/zsh-plugins/gitstatus.plugin.zsh
export GITSTATUS_DAEMON="$(which gitstatusd)"

# antibody for the rest of zsh plugins:
source <(antibody init)
antibody bundle < ~/.zsh/plugins.txt



