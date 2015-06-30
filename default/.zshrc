# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="powerlevel9k/powerlevel9k"

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

# Check if my oh-my-zsh customizations are available
if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ]]; then
	echo "Installing powerlevel9k..."
	mkdir -p $HOME/.oh-my-zsh/custom/themes/powerlevel9k
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
	rm -rf ~/.oh-my-zsh/custom/themes/powerlevel9k/.git
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

source $ZSH/oh-my-zsh.sh

# Load .profile (may be redundant)
source ~/.profile

# DNVM stuff
[ -s "/home/cole/.dnx/dnvm/dnvm.sh" ] && . "/home/cole/.dnx/dnvm/dnvm.sh"

# Tmux stuff
if [[ -z "$TMUX" ]]; then
	tmux att || tmux
fi

#if [ -d /home/cole/Code/GoogleCloudPlatform/google-cloud-sdk ]; then
#	source '/home/cole/Code/GoogleCloudPlatform/google-cloud-sdk/completion.zsh.inc'
#	source '/home/cole/Code/GoogleCloudPlatform/google-cloud-sdk/path.zsh.inc'
#fi
