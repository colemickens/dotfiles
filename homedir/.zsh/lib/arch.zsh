archup() {
	yaourt -Syua --noconfirm
}

reflector_run() {
	wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
	&& reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
	&& sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
	&& sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}

arch_bootstrap() {
	set -x
	yaourt -Syua --needed --noconfirm \
		zsh mosh openssh vim stow wget curl htop docker \
		git subversion mercurial \
		go python ruby perl rustup npm nodejs \
		jq tig parallel jenkins weechat gist fzf python-pip rsync reflector \
		kubectl-bin kubernetes-helm \
		asciinema bind-tools weechat mitmproxy neofetch \
		libu2f-host \
		python-azure-cli
}

arch_bootstrap_gui() {
	set -x
	arch_bootstrap
	yaourt -S --needed \
		google-chrome-dev vlc firefox \
		gedit remmina visual-studio-code-insiders \
		gnome-screenshot gnome-boxes cheese eog \
		skypeforlinux-bin
}

pixelup() {
	yaourt -S linux-samus4 --noconfirm
}

arch_update_vsci() {
	set -x
	D=$(mktemp -d)
	trap "rm -rf $D" EXIT
	cd $D
	git clone https://aur.archlinux.org/visual-studio-code-insiders.git/ .
	makepkg -si --skipinteg
}
