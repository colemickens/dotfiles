#!/bin/bash

function install_package() {
	tDir=$(mktemp -d)
	cd "${tDir}"
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz
	tar xvzf $1.tar.gz
	cd $1
	makepkg -s
	sudo pacman --noconfirm -U $1*.tar.xz
	cd $HOME
	rm -rf $tDir
}

sudo bash -c "printf \"\n\" | pacman -S --needed base-devel wget curl"

if [ -z "$(pacman -Qs package-query)" ]; then
	install_package package-query
fi


if [ -z "$(pacman -Qs yaourt)" ]; then
	install_package yaourt
fi


yaourt -S --needed --noconfirm \
	zsh sudo htop openssh mosh docker \
	make cmake git svn mercurial gitg \
	hexchat vlc alsa-utils pavucontrol gptfdisk gnome-disk-utility t\
	gdm gnome-shell nautilus gedit gnome-control-center gnome-tweak-tool file-roller eog evince \
	firefox mitmproxy reflector redshift gimp \
	libvirt virt-manager avahi \
	xorg-server xorg-server-utils xf86-video-intel xf86-input-libinput xclip xsel xorg-xprop xorg-xwininfo \
	\
	google-chrome google-chrome-dev \
	dropbox imgurbash scrot gist \
	gtk-theme-arc-git ultra-flat-icons vertex-themes \
	powerline-fonts-git ttf-ms-fonts ttf-google-fonts-git \
	nodejs-azure-cli aws-cli \
	visual-studio-code sublime-text-nightly neovim-git smartsynchronize \
	multirust \
	slack-desktop

sudo systemctl enable docker.service
sudo systemctl enable sshd.service
sudo systemctl enable avahi-daemon.service
sudo systemctl enable avahi-dnsconfd.service
sudo systemctl enable gdm.service

sudo gpasswd -a cole docker

# use nvim everywhere instead of vim

if [ -z "$(pacman -Qs vi)" ]; then yaourt -R vi; fi
if [ -z "$(pacman -Qs vim)" ]; then yaourt -R vim; fi

yaourt -S --needed neovim-symlinks --noconfirm

yaourt -Syua

echo "done"
