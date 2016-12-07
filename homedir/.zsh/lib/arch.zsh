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
		kubectl-bin helm-git \
		asciinema bind-tools weechat mitmproxy neofetch \
		libu2f-host \
		#record-query-git \

	sudo gpasswd -a "$(id -nu)" docker

	arch_update_az
	arch_update_azure_legacy
}

arch_update_azure_legacy() {
	# legacy 'azure' azure-xplat-cli
	mkdir -p "${HOME}/.local/share/nodejs"
	npm install --quiet --global --prefix="${HOME}/.local/share/nodejs" 'azure-cli'
}

arch_update_az() {
	# new 'az' azure-cli
	#pip install --user --upgrade --quiet 'azure-cli'
	rm -rf /home/cole/.local/lib/python3.5/site-packages/*az*
	pip install --user --upgrade --pre azure-cli --extra-index-url https://azureclinightly.blob.core.windows.net/packages

	# optional modules:
	#export AZURE_COMPONENT_PACKAGE_INDEX_URL=https://azureclinightly.blob.core.windows.net/packages
    #az component update --add keyvault --private
	pip install --user --upgrade --pre azure-cli-keyvault --extra-index-url https://azureclinightly.blob.core.windows.net/packages
}

arch_bootstrap_gui() {
	set -x
	yaourt -S --needed \
		google-chrome-dev vlc firefox \
		gedit visual-studio-code-bin \
		remmina slack-desktop skype-for-linux-beta \
		gnome-screenshot gnome-boxes cheese gnome-image-viewer
}
