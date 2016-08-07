### zsh
export DEFAULT_USER="cole"
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
setopt AUTO_CD
setopt inc_append_history
setopt share_history
mkdir -p "$HOME/.zsh/completions"
fpath=(~/.zsh/completions $fpath)

### env
export HOSTNAME="$(hostname)"
export UNAMESTR="$(uname)"
export PLATFORM_OS="unknown"
export PLATFORM_DISTRO="unknown"
export PLATFORM_ARCH="unknown"
export NPROC=1
if [[ "${UNAMESTR}" == "Darwin" ]]; then
	export PLATFORM_OS="macos"
	export PLATFORM_DISTRO=""
	export PLATFORM_ARCH="amd64"
	export NPROC="$(sysctl -n hw.ncpu)"
elif [[ "${UNAMESTR}" == "Linux" ]]; then
	export PLATFORM_OS="linux"
	export PLATFORM_DISTRO="$(source /etc/os-release; echo "${ID}")"
	export PLATFORM_ARCH="amd64"
	export NPROC="$(nproc)"
fi

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
zplug "junegunn/fzf", use:"shell/*.zsh"
zplug "supercrabtree/k"
zplug "b4b4r07/enhancd"
zplug "lib/completion",            from:oh-my-zsh
zplug "lib/correction",            from:oh-my-zsh
zplug "lib/key-bindings",          from:oh-my-zsh
#zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
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

source <(azure --completion)
source <(kubectl completion zsh)


### Tmux info
if [[ -z "$TMUX" ]]; then
	tmux ls
fi;

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
