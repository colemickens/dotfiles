#!/usr/bin/env bash

set -x

HOSTNAME="$(hostname)"

sudo true

mkdir -p ~/.ssh
mkdir -p ~/code/colemickens

ssh-keygen -f ~/.ssh/id_rsa -t rsa -C "cole.mickens@gmail.com" -N ''

git clone https://github.com/colemickens/dotfiles ~/code/colemickens
(cd ~/code/colemickens/dotfiles; ./stow.sh)

source ~/.zprofile

github_add_publickey

mkdir -p code/colemickens

git clone git@github.com/colemickens/dotfiles $HOME/code/colemickens/dotfiles

sudo git clone git@github.com/colemickens/nixpkgs /nixpkgs
sudo chown cole:users /nixpkgs

# run tmux insatll
nvim -c ":PlugInstall | q | q | q" &> /dev/null

sudo nixos-rebuild --switch
sudo reboot
