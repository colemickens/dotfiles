reflector_run() {
	wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
		&& reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
		&& sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
		&& sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}

aur() {
	arch_bootstrap_pacaur
	pacaur --noconfirm --noedit $@
}

archup() {
	aur -Syua
	_archup_gui_extra
}

arch_bootstrap_pacaur() {
	if ! which pacaur ; then
		gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

		# pacaur dependencies
		sudo pacman -S curl sudo git perl expac yajl --needed --noconfirm
	
		packages=(cower pacaur)
		for pkg in "${packages[@]}"
		do
			mkdir /tmp/$pkg
			chmod 0777 /tmp/$pkg
			(
				cd /tmp/$pkg
				curl "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=${pkg}" > PKGBUILD
				makepkg -s --noconfirm
				sudo pacman -U ./$pkg*.pkg.tar --noconfirm
			)
			rm -rf /tmp/$pkg
		done
	fi
}

arch_bootstrap() {
	set -x

	sudo pacman -S --needed --noconfirm \
		zsh tmux mosh openssh vim stow wget curl htop docker \
		git subversion mercurial \
		go python ruby perl rustup npm nodejs \
		jq tig parallel jenkins weechat gist fzf python-pip rsync reflector \
		asciinema bind-tools weechat mitmproxy \
		libu2f-host \
		neovim

	aur -S --needed kubectl-bin kubernetes-helm

	sudo systemctl enable docker libvirtd
	sudo systemctl start docker libvirtd

	sudo gpasswd -a ${USER} libvirtd
	sudo gpasswd -a ${USER} kvm
	sudo gpasswd -a ${USER} docker
}

arch_bootstrap_gui() {
	set -x
	arch_bootstrap

	# All (except git/latest packages)
	sudo pacman -S --needed --noconfirm \
		networkmanager \
		vlc \
		ttf-fira-mono

	# GNOME
	sudo pacman -S --needed --noconfirm \
		gdm gedit eog cheese remmina \
		gnome-{boxes,builder,control-center,screenshot,session,shell,tweak-tool} \
		

	# KDE
	sudo pacman -S --needed --noconfirm \
		plasma \
		plasma-desktop plasma-wayland-session \
		plasma5-applets-redshift-control plasma-nm \
		kdemultimedia-kmix kscreen powerdevil bluedevil kwalletmanager \
		kate spectacle \
		breeze-gtk kde-gtk-config

	sudo pacman -R --noconfirm discover || true # does weird stuff in Arch

	sudo systemctl enable sddm
	sudo systemctl enable NetworkManager
	sudo systemctl enable bluetooth

	# this gets/updates the random stuff from AUR
	archup
}

pixelup() {
	aur -S linux-samus4 --noconfirm
}

_archup_gui_extra() {
	set -x

	# not totally sure if necessary. considerations:
	# 1. does 'pacaur' always check the latest/git packages? seems no
	# 2. need skipinteg for a number of the git/latest packages (shouldn't they SKIP since they're pulling from git anyway?)
	# hmmm....

	MAKEPKG="makepkg --skipinteg" aur -S --needed \
		visual-studio-code-insiders \
		firefox-nightly \
		chrome-gnome-shell-git \
		gtk-theme-arc-git \
		numix-circle-icon-theme-git \
		google-chrome-dev \
		skypeforlinux-bin \
		emojione-fonts \
		ttf-ms-fonts
}
