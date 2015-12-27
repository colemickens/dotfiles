#!/usr/bin/env sh

set -x

case $(hostname) in
	chimera)
		sudo stow server_rootdir --no-folding -t /
		sudo stow common_rootdir --no-folding -t /
		stow common_homedir --no-folding -t $HOME/
		stow personal_homedir --no-folding -t $HOME/
		sudo systemctl restart nginx
		;;
	pixel)
		sudo stow common_rootdir --no-folding -t /
		stow common_homedir --no-folding -t $HOME/
		stow personal_homedir --no-folding -t $HOME/
		;;
	nucleus)
		sudo stow common_rootdir --no-folding -t /
		stow common_homedir --no-folding -t $HOME/
		stow personal_homedir --no-folding -t $HOME/
		;;
	cmcrbn)
		sudo stow common_rootdir --no-folding -t /
		stow common_homedir --no-folding -t $HOME/
		stow work_homedir --no-folding -t $HOME/
		;;
	*)
		echo "Unknown hostname! Update me!"
esac

