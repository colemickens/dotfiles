basics() {
	if [[ $EUID -ne 0 ]]; then
		echo "This function must be run as root" 1>&2
		exit 1
	fi

	pacman -S base-devel wget curl

	pqDir=$(mktemp -d)
	cd "${pqDir}"
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
	tar xvzf package-query.tar.gz
	cd package-query
	makepkg -s
	pacman -U package-query*.tar.gz


	yaourtDir=$(mktemp -d)
	cd "${yaourtDir}"
	wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
	tar xvzf yaourt.tar.gz
	cd yaourt
	makepkg -s
	pacman -U yaourt*.tar.gz

	cd $HOME
	rm -rf "${pqDir}"
	rm -rf "${yaourtDir}"

	yaourt -S \
		zsh sudo htop vim openssh mosh docker \
		make cmake git svn mercurial gitg \
		gnome-shell nautilus gedit gnome-control-center gnome-tweak-tool file-roller eog evince \
		firefox mitmproxy reflector redshift gimp \
		libvirt virt-manager \
		xorg-xprop xorg-xwininfo xorg-server xorg-server-utils xf86-input-libinput xclip xsel \
		\
		google-chrome google-chrome-dev \
		dropbox imgurbash scrot \
		gtk-theme-arc-git ultra-flat-icons vertex-themes \
		powerline-fonts-git ttf-ms-fonts ttf-google-fonts-git \
		nodejs-azure-cli aws-cli \
		visual-studio-core sublime-text-nightly smartsynchronize \
		multirust

	systemctl enable docker
	systemctl enable sshd

	# enable wheel for sudo
	sudo cp /etc/sudoers /etc/sudoers.tmp
	echo "" >> /etc/sudoers.tml
	if [ visudo -c -f /tmp/sudoers.tmp ]; then 
		cp /tmp/sudoers.new /etc/sudoers
		rm /etc/sudoers.tmp
	else
		echo "failed to enable wheel group for sudo"
	fi

	# make me a user account
	useradd -m -G wheel,docker -s /bin/zsh cole
}

setup_cole() {
	sudo cole
	mkdir -p $HOME/Code/colemickens/
	git clone git@github.com:colemickens/stowed.git $HOME/Code/colemickens/stowed
}

setup_chimera() {
	# install deluge (web)
	# install twitlistauth maybe?
	# install cloudflare dyndns client
}

setup_laptop() {
	yaourt -S laptop-mode-tools
	sudo systemctl enable laptop-mode.service
}

"@"