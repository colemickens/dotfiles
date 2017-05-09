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
	yaourt -Syua --needed --noconfirm \
		zsh mosh openssh vim stow wget curl htop docker \
		git subversion mercurial \
		go python ruby perl rustup npm nodejs \
		jq tig parallel jenkins weechat gist fzf python-pip rsync reflector \
		kubectl-bin kubernets-helm \
		asciinema bind-tools weechat mitmproxy neofetch \
		libu2f-host \
		kakoune-git \
		remarshal hub

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
	rm -rf $HOME/.local/lib/python3.6
	mkdir $HOME/.local/lib/python3.6/site-packages
	pip install --no-cache-dir --user --upgrade --pre azure-cli --extra-index-url https://azureclinightly.blob.core.windows.net/packages

	# optional modules:
	#export AZURE_COMPONENT_PACKAGE_INDEX_URL=https://azureclinightly.blob.core.windows.net/packages
	#az component update --add keyvault --private
	pip install --user --upgrade --pre azure-cli-acr azure-cli-keyvault --extra-index-url https://azureclinightly.blob.core.windows.net/packages
}

arch_bootstrap_gui() {
	set -x
	yaourt -S --needed \
		google-chrome-dev vlc firefox \
		gedit visual-studio-code-bin \
		remmina slack-desktop skype-for-linux-beta \
		gnome-screenshot gnome-boxes cheese gnome-image-viewer
}
