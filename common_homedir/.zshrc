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
