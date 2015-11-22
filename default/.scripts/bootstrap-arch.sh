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

function remove_if_installed() {
	if pacman -Q $1 >/dev/null 2>&1 ; then
		yaourt -R $1
	fi
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
	hexchat vlc alsa-utils pavucontrol gptfdisk gnome-disk-utility \
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

# enable services
sudo systemctl enable docker.service
sudo systemctl enable sshd.service
sudo systemctl enable avahi-daemon.service
sudo systemctl enable avahi-dnsconfd.service
sudo systemctl enable gdm.service

sudo gpasswd -a cole docker >/dev/null 2>&1

# enable avahi dns
yaourt -S --needed --noconfirm nss-mdns
# if ^hosts: line doesn't contain mdns_minimal, add it
sudo cp -f /etc/nsswitch.conf /etc/nsswitch.conf.pre-mdns
sudo bash -c "sed -e '/mdns/!s/^\(hosts:.*\)dns\(.*\)/\1mdns_minimal dns\2/' /etc/nsswitch.conf.pre-mdns > /etc/nsswitch.conf"

# use nvim everywhere instead of vim
remove_if_installed vi
remove_if_installed vim
yaourt -S --needed neovim-symlinks --noconfirm

# do updates just in case
yaourt -Syua

if [ `hostname` == "pixel" ]; then
	# do pixel specific stuff
	yaourt -S --needed --noconfirm laptop-mode-tools
	sudo systemctl enable laptop-mode.service
fi

echo "done"
