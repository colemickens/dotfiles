#!/usr/bin/env sh

set -x

function common() {
	rm -f ~/.config/hexchat/hexchat.conf
	stow common_homedir --no-folding -t $HOME/
}

case $(hostname) in
	chimera)
		sudo stow server_rootdir --no-folding -t /
		common
		stow personal_homedir --no-folding -t $HOME/
		sudo systemctl restart nginx
		;;
	pixel)
		common
		stow personal_homedir --no-folding -t $HOME/
		;;
	nucleus)
		common
		stow personal_homedir --no-folding -t $HOME/
		;;
	cmcrbn)
		common
		stow work_homedir --no-folding -t $HOME/
		;;
	*)
		echo "Unknown hostname! Update me!"
esac

