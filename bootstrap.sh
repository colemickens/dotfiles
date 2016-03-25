#!/usr/bin/env zsh

set -x

HOSTNAME="$(hostname)"

sudo true

mkdir -p ~/.ssh
mkdir -p ~/code/colemickens
mkdir -p ~/code/azure

ssh-keygen -f ~/.ssh/id_rsa -t rsa -C "cole.mickens@gmail.com" -N ''

git clone https://github.com/colemickens/dotfiles ~/code/colemickens/dotfiles
(cd ~/code/colemickens/dotfiles; ./stow.sh)

source ~/.zprofile

github_add_publickey

(cd ~/code/colemickens/dotfiles; git remote set-url origin git@github.com:colemickens/dotfiles.git)

git clone git@github.com:colemickens/nixops ~/code/colemickens/nixops
git clone git@github.com:colemickens/kubernetes ~/code/azure/kubernetes

sudo git clone git@github.com:colemickens/nixpkgs /nixpkgs
git clone git@github.com:colemickens/nixpkgs /nixpkgs
sudo chown cole:users /nixpkgs

nvim -c ":PlugInstall | q | q | q" &> /dev/null

sudo rm /etc/nixos/configuration.nix
sudo ln -s ~/code/colemickens/dotfiles/nixcfg/devices/azurevm/configuration.nix /etc/nixos/configuration.nix

export NIX_PATH=nixos-config=/etc/nixos/configuration.nix:nixpkgs=/nixpkgs
sudo nixos-rebuild switch # this doesn't work, kind of important

read -q
sudo reboot
