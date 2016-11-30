archup() {
	yaourt -Syua --noconfirm
}
pacman_clean() { sudo pacman -Sc; sudo pacman -Scc; }

reflector_run() {
	wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
	&& reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
	&& sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
	&& sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}

arch_bootstrap() {
	set -x
	yaourt -S --needed \
		zsh mosh openssh vim stow wget curl htop docker \
		git subversion mercurial \
		go python ruby perl rustup npm nodejs \
		jq tig parallel jenkins weechat gist fzf python-pip rsync reflector \
		kubectl-bin \
		asciinema bind-tools weechat mitmproxy

	sudo gpasswd -a "$(id -nu)" docker

	mkdir -p "${HOME}/.local/share/nodejs"
	pip install --user --upgrade --quiet 'azure-cli'
	npm install --quiet --global --prefix="${HOME}/.local/share/nodejs" 'azure-cli'
}
