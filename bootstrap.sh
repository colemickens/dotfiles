#!/usr/bin/env zsh

set -x

HOSTNAME="$(hostname)"

sudo true

mkdir -p ~/.ssh
mkdir -p ~/code/colemickens

ssh-keygen -f ~/.ssh/id_rsa -t rsa -C "cole.mickens@gmail.com" -N ''

git clone https://github.com/colemickens/dotfiles ~/code/colemickens/dotfiles
(cd ~/code/colemickens/dotfiles; ./stow.sh)

source ~/.zprofile

github_add_publickey

(cd ~/code/colemickens/dotfiles; git remote set-url origin git@github.com:colemickens/dotfiles.git)

sudo git clone git@github.com/colemickens/nixpkgs /nixpkgs
sudo chown cole:users /nixpkgs

# run tmux insatll
nvim -c ":PlugInstall | q | q | q" &> /dev/null

sudo nixos-rebuild --switch
sudo reboot
