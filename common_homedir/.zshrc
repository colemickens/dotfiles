#
# User configuration sourced by interactive shells
#

# Source zim
if [ ! -d ${ZDOTDIR:-${HOME}}/.zim ]; then
 	git clone https://github.com/Eriner/zim.git ${ZDOTDIR:-${HOME}}/.zim
fi
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

DEFAULT_USER="cole"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git)

#if [ ! -f $ZSH/oh-my-zsh.sh ]; then
#	git clone https://github.com/robbyrussell/oh-my-zsh.git $ZSH
#fi
#source $ZSH/oh-my-zsh.sh

# if [ ! -d ${ZDOTDIR:-${HOME}}/.zim ]; then
# 	git clone https://github.com/Eriner/zim.git ${ZDOTDIR:-${HOME}}/.zim
#fi
#source ~/.zim/init.zsh

source $HOME/.zprofile

source $HOME/.scripts/zsh/tmux-pane-completion.zsh

export TERMINAL="termite"

# stupid workaround until coreutils is updated to support termite
if true; then
	dircolorstemp="$(mktemp -d)"
	dircolors -p > $dircolorstemp/dircolors
	last_line="$(grep -n TERM $dircolorstemp/dircolors | tail -1 | cut -d : -f 1)"
	next_line="$((last_line + 1))"
	sed -i "${next_line}i TERM xterm-termite" $dircolorstemp/dircolors
	eval $(dircolors $dircolorstemp/dircolors)
	rm -rf "$dircolorstemp"
fi
