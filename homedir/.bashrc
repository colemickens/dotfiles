export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"

export SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9YAN+P0umXeSP/Cgd5ZvoD5gpmkdcrOjmHdonvBbptbMUbI/Zm0WahBDK0jO5vfJ/C6A1ci4quMGCRh98LRoFKFRoWdwlGFcFYcLkuG/AbE8ObNLHUxAwqrdNfIV6z0+zYi3XwVjxrEqyJ/auZRZ4JDDBha2y6Wpru8v9yg41ogeKDPgHwKOf/CKX77gCVnvkXiG5ltcEZAamEitSS8Mv8Rg/JfsUUwULb6yYGh+H6RECKriUAl9M+V11SOfv8MAdkXlYRrcqqwuDAheKxNGHEoGLBk+Fm+orRChckW1QcP89x6ioxpjN9VbJV0JARF+GgHObvvV+dGHZZL1N3jr8WtpHeJWxHPdBgTupDIA5HeL0OCoxgSyyfJncMl8odCyUqE+lqXVz+oURGeRxnIbgJ07dNnX6rFWRgQKrmdV4lt1i1F5Uux9IooYs/42sKKMUQZuBLTN4UzipPQM/DyDO01F0pdcaPEcIO+tp2U6gVytjHhZqEeqAMaUbq7a6ucAuYzczGZvkApc85nIo9jjW+4cfKZqV8BQfJM1YnflhAAplIq6b4Tzayvw1DLXd2c5rae+GlVCsVgpmOFyT6bftSon/HfxwBE4wKFYF7fo7/j6UbAeXwLafDhX+S5zSNR6so1epYlwcMLshXqyJePJNhtsRhpGLd9M3UqyGDAFoOQ== cardno:000607532298"

export BASH_COLOR="1;32" && export TMUXCOLOR="green"
[[ "${HOSTNAME}" == "xeep" ]]    && export BASH_COLOR="1;35" && export TMUXCOLOR="magenta"
[[ "${HOSTNAME}" == "chimera" ]] && export BASH_COLOR="1;36" && export TMUXCOLOR="cyan"

# prompt
PROMPT_COLOR="1;31m"
let $UID && PROMPT_COLOR="${BASH_COLOR}m"
PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
if test "$TERM" = "xterm"; then
  PS1="\[\033]2;\h:\u:\w\007\]$PS1"
fi

function gpgssh() {
  set -x
  ssh \
    -v \
    -o "RemoteForward /run/user/1000/gnupg/S.gpg-agent:/run/user/1000/gnupg/S.gpg-agent.extra" \
    -o StreamLocalBindUnlink=yes \
    -A \
    "${@}"
  set +x
}

function _nixup() { sudo nixos-rebuild switch; which flatpak &>/dev/null && sudo flatpak update -y; }
function _reset_pinentry () { pkill pinentry; echo 'UPDATESTARTUPTTY' | gpg-connect-agent; export GPG_TTY=$(tty); }

if [[ "$SSH_AUTH_SOCK" == "/run/user/$(id -u)/keyring/ssh" ]]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

export FZF_TMUX=1
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

