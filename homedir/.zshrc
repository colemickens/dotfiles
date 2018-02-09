export PATH="${HOME}/.local/share/nodejs/bin:${PATH}"
export PATH="${HOME}/.cargo/bin:${PATH}"
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/Library/Python/2.7/bin:${PATH}"
export EDITOR="nvim"

## Firefox
export MOZ_USE_XINPUT2=1

### zsh
export DEFAULT_USER="cole"
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="$HOME/.zhistory"
#setopt AUTO_CD
setopt inc_append_history
setopt share_history
setopt HIST_SAVE_NO_DUPS
mkdir -p "$HOME/.zsh/completions"
fpath=(~/.zsh/completions $fpath)

## nvim settings that must be env vars? TODO: check on this
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

### env
export PLATFORM_OS="unknown"
export PLATFORM_DISTRO="unknown"
export PLATFORM_ARCH="unknown"
export NPROC=1
if [[ "$(uname)" = "Darwin" ]]; then
	export PLATFORM_OS="macos"
	export PLATFORM_DISTRO=""
	export PLATFORM_ARCH="amd64"
	export NPROC="$(sysctl -n hw.ncpu)"
elif [[ "$(uname)" == "Linux" ]]; then
	export PLATFORM_OS="linux"
	export PLATFORM_DISTRO="$(source /etc/os-release; echo "${ID}")"
export HOSTNAME="$(hostname)"
	export PLATFORM_ARCH="amd64"
	export NPROC="$(nproc)"
fi

export MAKEFLAGS="-j${NPROC}"

### powerlevel9k config
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


### zplug
export ZPLUG_HOME=$HOME/.zplug
[[ -d ~/.zplug ]] || {
	mkdir -p $ZPLUG_HOME
	git clone https://github.com/zplug/zplug $ZPLUG_HOME
	source ~/.zplug/init.zsh && zplug update --self
}
source ~/.zplug/init.zsh
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
zplug "zsh-users/zsh-completions"
zplug "willghatch/zsh-saneopt"
zplug "b4b4r07/enhancd"
zplug "lib/completion",            from:oh-my-zsh
zplug "lib/correction",            from:oh-my-zsh
zplug "lib/key-bindings",          from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "junegunn/fzf", use:"shell/*.zsh"
if ! zplug check --verbose; then
	zplug install
fi
zplug load


### vim: dein
DEIN_HOME="$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim"
[[ -d "${DEIN_HOME}" ]] || {
	mkdir -p "${DEIN_HOME}"
	git clone https://github.com/Shougo/dein.vim ${DEIN_HOME}
}


### ls, with color!
if [[ "${PLATFORM_OS}" == "linux" ]]; then
	alias l='ls -alh'
	alias ll='ls -l'
	alias ls='ls --color=auto'
elif [[ "${PLATFORM_OS}" == "macos" ]]; then
	alias l='ls -alh'
	alias ll='ls -l'
	alias ls='ls -G'
fi


### Tmux info
if [[ -z "$TMUX" ]]; then
	tmux ls 2>/dev/null
fi
if [[ "$(hostname)" == "azdev" ]]; then
	export TMUX_HOSTNAME_COLOR=4
elif [[ "$(hostname)" == "pixel" || "$(hostname)" == "xeep" ]]; then
	export TMUX_HOSTNAME_COLOR=5
elif [[ "$(hostname)" == "chimera" ]]; then
	export TMUX_HOSTNAME_COLOR=2
fi

alias ll="LC_ALL=C ls -al --group-directories-first"

#source $HOME/.zsh/lib/aws.zsh
#source $HOME/.zsh/lib/azure.zsh
#source $HOME/.zsh/lib/docker.zsh
#source $HOME/.zsh/lib/gcp.zsh
#source $HOME/.zsh/lib/golang.zsh
#source $HOME/.zsh/lib/gotty.zsh
#source $HOME/.zsh/lib/kubernetes.zsh
#source $HOME/.zsh/lib/macos.zsh
#source $HOME/.zsh/lib/maintenance.zsh
#source $HOME/.zsh/lib/misc.zsh
#source $HOME/.zsh/lib/mitmproxy.zsh
#source $HOME/.zsh/lib/rdp.zsh
#source $HOME/.zsh/lib/ssh.zsh

#if [[ "$(hostname)" == "pixel" ]]; then
#	source $HOME/.zsh/lib/pixel.zsh
#fi

#if [[ "$PLATFORM_DISTRO" == "arch" ]]; then
#	source $HOME/.zsh/lib/arch.zsh
#fi

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

source <(kubectl completion zsh)
alias k="kubectl"

