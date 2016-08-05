if [[ "$PLATFORM_DISTRO" == "arch" ]]; then
	archup() { sudo true; yaourt -Syua --noconfirm }
	pacman_clean() { sudo pacman -Sc; sudo pacman -Scc; }

	reflector_run() {
		sudo true
		wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
		&& reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
		&& sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
		&& sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
	}
fi
