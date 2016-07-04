DEFAULT_USER="cole"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

source ~/.zprofile
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"

##############################################################################
# config for stuff loaded by zplug
##############################################################################
POWERLEVEL9K_MODE="compatible"

POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_VCS_BRANCH_ICON=''

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_ccontext dir vcs status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time)
POWERLEVEL9K_STATUS_VERBOSE=false

POWERLEVEL9K_CUSTOM_CCONTEXT="hostname"
POWERLEVEL9K_CUSTOM_CCONTEXT_BACKGROUND="black"
POWERLEVEL9K_CUSTOM_CCONTEXT_FOREGROUND="white"


###############################################################################
# Zplug
###############################################################################
export ZPLUG_HOME=$HOME/.zplug
[[ -d ~/.zplug ]] || {
  mkdir -p $ZPLUG_HOME
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  source ~/.zplug/init.zsh && zplug update --self
}

# Essential
source ~/.zplug/init.zsh

# Make sure to use double quotes to prevent shell expansion
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"

# Install plugins that have not been installed yet
if ! zplug check --verbose; then
  zplug install
fi

zplug load

if zplug check zsh-users/zsh-history-substring-search; then
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
fi

zstyle ':completion:*' menu select
bindkey '^[[Z'    reverse-menu-complete


###############################################################################
# Vim-plug
###############################################################################
[[ -f "$HOME/.config/nvim/autoload/plug.vim" ]] || {
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}


###############################################################################
# coreutils - workaround for termite
###############################################################################
if [[ "${PLATFORM_OS}" == "linux" ]]; then
	if true; then
		dircolorstemp="$(mktemp -d)"
		dircolors -p > "$dircolorstemp/dircolors"
		last_line="$(grep -n TERM $dircolorstemp/dircolors | tail -1 | cut -d : -f 1)"
		next_line="$((last_line+1))"
		sed -i "${next_line}i TERM xterm-termite" "$dircolorstemp/dircolors"
		eval $(dircolors "$dircolorstemp/dircolors")
		rm -rf "${dircolorstemp}"
	fi
fi


###############################################################################
# colored ls output
###############################################################################
if [[ "${PLATFORM_OS}" == "linux" ]]; then
	alias l='ls -alh'
	alias ll='ls -l'
	alias ls='ls --color=auto'
elif [[ "${PLATFORM_OS}" == "mac" ]]; then
	alias l='ls -alh'
	alias ll='ls -l'
	alias ls='ls -G'
fi


###############################################################################
# fzf - load
###############################################################################
if [ -d "$HOME/.fzf/shell" ]; then
	source "$HOME/.fzf/shell/completion.zsh"
	source "$HOME/.fzf/shell/key-bindings.zsh"
fi


###############################################################################
# tmux - auto attach or start new session
###############################################################################
if [[ -z "$TMUX" ]]; then
	tmux ls
fi;

autoload -U compinit && compinit
source <(kubectl completion zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
