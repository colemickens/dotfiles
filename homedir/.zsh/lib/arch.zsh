# to get pacaur installed:
# gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

# TODO: get pacaur to actually not prompt

archup() {
	pacaur -Syua --noconfirm
}

reflector_run() {
	wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
	&& reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
	&& sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
	&& sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}

arch_bootstrap() {
	set -x
	sudo pacman -Syu --needed --noconfirm \
		zsh tmux mosh openssh vim stow wget curl htop docker \
		git subversion mercurial \
		go python ruby perl rustup npm nodejs \
		jq tig parallel jenkins weechat gist fzf python-pip rsync reflector

	pacaur -S --needed --noconfirm
		kubectl-bin kubernetes-helm \
		asciinema bind-tools weechat mitmproxy \
		libu2f-host \
		neovim \
		python-azure-cli nodejs-azure-cli
}

arch_bootstrap_gui() {
	set -x
	arch_bootstrap

	# main repo GUI apps
	sudo pacman -S --needed --noconfirm \
		firefox chromium \
		gedit gnome-{screenshot,boxes,tweak-tool} \
		remmina cheese eog vlc

	# other AUR applications
	pacaur -S --needed --noconfirm google-chrome-dev
	pacaur -S --needed --noconfirm google-chrome-beta
	pacaur -S --needed --noconfirm skypeforlinux-bin
	pacaur -S --needed --noconfirm chrome-gnome-shell-git

	# appearance
	pacaur -S --needed --noconfirm \
		gtk-theme-arc-git \
		numix-circle-icon-theme-git \
		ttf-ms-fonts ttf-fira-mono ttf-fira-code
}

pixelup() {
	pacaur -S linux-samus4 --noconfirm
}

arch_update_vsci() {
	set -x
	D=$(mktemp -d)
	trap "rm -rf $D" EXIT
	cd $D
	git clone https://aur.archlinux.org/visual-studio-code-insiders.git/ .
	makepkg -si --skipinteg
}
