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
	gdm gnome-shell nautilus gedit gnome-control-center gnome-tweak-tool file-roller eog evince \
	firefox mitmproxy reflector redshift gimp \
	libvirt virt-manager avahi \
	xorg-xprop xorg-xwininfo xorg-server xorg-server-utils xf86-input-libinput xclip xsel \
	\
	google-chrome google-chrome-dev \
	dropbox imgurbash scrot \
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

# use nvim everywhere instead of vim
yaourt -R vi vim
yaourt -S --needed neovim-symlinks --noconfirm
