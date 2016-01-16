#
# startup file read in interactive login shells
#
# The following code helps us by optimizing the existing framework.
# This includes zcompile, zcompdump, etc.
#

(
  # Function to determine the need of a zcompile. If the .zwc file
  # does not exist, or the base file is newer, we need to compile.
  # These jobs are asynchronous, and will not impact the interactive shell
  zcompare() {
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
      zcompile ${1}
    fi
  }

  # First, we will zcompile the completion cache, if it exists. Siginificant speedup.
  zcompare ${ZDOTDIR:-${HOME}}/.zcompdump

  # Next, zcompile .zshrc if needed
  zcompare ${ZDOTDIR:-${HOME}}/.zshrc

  # Now, zcompile some light module init scripts
  zcompare ${ZDOTDIR:-${HOME}}/.zim/modules/git/init.zsh
  zcompare ${ZDOTDIR:-${HOME}}/.zim/modules/utility/init.zsh
  zcompare ${ZDOTDIR:-${HOME}}/.zim/modules/pacman/init.zsh
  zcompare ${ZDOTDIR:-${HOME}}/.zim/modules/spectrum/init.zsh
  zcompare ${ZDOTDIR:-${HOME}}/.zim/modules/completion/init.zsh
  zcompare ${ZDOTDIR:-${HOME}}/.zim/modules/custom/init.zsh

  # Then, we should zcompile the 'heavy' modules where possible.
  # This includes syntax-highlighting and completion. 
  # Other modules may be added to this list at a later date.
  zim=${ZDOTDIR:-${HOME}}/.zim
  setopt EXTENDED_GLOB

  #
  # syntax-highlighting zcompile
  #
  if [[ -d ${zim}/modules/syntax-highlighting/external/highlighters ]]; then
    # compile the highlighters
    for file in ${zim}/modules/syntax-highlighting/external/highlighters/**/*.zsh; do
      zcompare ${file}
    done
    # compile the main file
    zcompare ${zim}/modules/syntax-highlighting/external/zsh-syntax-highlighting.zsh
  fi

  #
  # zsh-histery-substring-search zcompile
  #
  if [[ -s ${zim}/modules/history-substring-search/external/zsh-history-substring-search.zsh ]]; then
    zcompare ${zim}/modules/history-substring-search/external/zsh-history-substring-search.zsh
  fi
  

) &!

# zim stuff ^^^^ 

# my stuff vvvv

export TERMINAL="termite"

if [[ `/usr/bin/env hostname` == "pixel" ]]; then
	export GDK_SCALE=2
fi

