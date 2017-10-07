reflector_run() {
	wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
		&& reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
		&& sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
		&& sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}

aur() {
	pacaur --noconfirm --noedit $@
}

archup() {
	aur -Syua
}

# TODO: replace with "bootstrap_pacaur"
#arch_bootstrap_aur() {
#	gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
#	
#	packages=(package-query aur)
#	sudo pacman -S base-devel yajl --needed --noconfirm
#	for pkg in "${packages[@]}"
#	do
#		mkdir /tmp/$pkg
#		chmod 0777 /tmp/$pkg
#		(
#			cd /tmp/$pkg
#			curl "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=${pkg}" > PKGBUILD
#			makepkg -s --noconfirm
#			sudo pacman -U ./$pkg*.pkg.tar --noconfirm
#		)
#		rm -rf /tmp/$pkg
#	done
#}

arch_bootstrap() {
	set -x

	# TODO: make the following bit idempotent
	# arch_bootstrap_aur

	aur -S --needed --noconfirm \
		zsh tmux mosh openssh vim stow wget curl htop docker \
		git subversion mercurial \
		go python ruby perl rustup npm nodejs \
		jq tig parallel jenkins weechat gist fzf python-pip rsync reflector \
		\
		kubectl-bin kubernetes-helm \
		asciinema bind-tools weechat mitmproxy \
		libu2f-host \
		neovim \
		#python-azure-cli
	
	sudo systemctl enable docker
	# TODO: I know this isn't needed, or great, but I'm already in 'wheel' group anyway
	# and some certain stuff assumes that they can call `docker` directly as the normal user...
	sudo gpasswd -a docker cole # TODO: dynamically do this based on whatever username is logged in (id -u) ?
}

arch_bootstrap_gui() {
	set -x
	arch_bootstrap

	# All
	aur -S --needed --noconfirm \
		networkmanager \
		remmina cheese eog vlc \
		\
		firefox-nightly \
		google-chrome-dev \
		skypeforlinux-bin \
		chrome-gnome-shell-git \
		\
		gtk-theme-arc-git \
		numix-circle-icon-theme-git \
		emojione-fonts \
		ttf-ms-fonts \
		ttf-fira-mono \
		ttf-fira-code

	# GNOME
	aur -S --needed --noconfirm \
		gdm gedit eog cheese \
		gnome-{boxes,builder,control-center,screenshot,session,shell,tweak-tool} \
		

	# KDE
	aur -S --needed --noconfirm \
		plasma-meta \
		plasma-desktop plasma-wayland-session \
		plasma5-applets-redshift-control plasma-nm \
		kdemultimedia-kmix kscreen powerdevil bluedevil kwalletmanager \
		kate spectacle \
		breeze-gtk kde-gtk-config

	aur -R discover || true # does weird stuff in Arch

	sudo systemctl enable sddm
	sudo systemctl enable NetworkManager
	sudo systemctl enable bluetooth

	arch_update_vsci
}

pixelup() {
	aur -S linux-samus4 --noconfirm
}

archup_extra() {
	set -x
	MAKEPKG="makepkg --skipinteg" aur -S \
		visual-studio-code-insiders \
		firefox-nightly \
		numix-circle-icon-theme-git
}
