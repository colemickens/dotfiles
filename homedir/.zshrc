DEFAULT_USER="cole"

##############################################################################
# Environment Detection (used in ~/.zprofile as well)
##############################################################################
export PLATFORM_DISTRO="$(source /etc/os-release; echo "${ID}")"
export PLATFORM_ARCH="$(echo "amd64")"
export PLATFORM_OS="$(echo "linux")"

##############################################################################
# config for stuff loaded by zplug
##############################################################################
POWERLEVEL9K_MODE="compatible"
ZLE_RPROMPT_INDENT=0 # removes the offset from the end of the right prompt

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
[[ -d ~/.zplug ]] || {
  curl -fLo ~/.zplug/zplug --create-dirs https://git.io/zplug
  source ~/.zplug/zplug && zplug update --self
}

# Essential
source ~/.zplug/zplug

# Make sure to use double quotes to prevent shell expansion
zplug "zsh-users/zsh-syntax-highlighting"
zplug "bhilburn/powerlevel9k", of:powerlevel9k.zsh-theme

# Install plugins that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

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
if true; then
	dircolorstemp="$(mktemp -d)"
	dircolors -p > "$dircolorstemp/dircolors"
	last_line="$(grep -n TERM $dircolorstemp/dircolors | tail -1 | cut -d : -f 1)"
	next_line="$((last_line+1))"
	sed -i "${next_line}i TERM xterm-termite" "$dircolorstemp/dircolors"
	eval $(dircolors "$dircolorstemp/dircolors")
	rm -rf "${dircolorstemp}"
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
	tmux attach || tmux new
fi;


###############################################################################
# Big Hammer
###############################################################################
source $HOME/.zprofile


