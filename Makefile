personal: FORCE
	stow default -t ~/
	stow personal -t ~/

work: FORCE
	stow default -t ~/
	stow work -t ~/

server: FORCE
	sudo stow server -t /

FORCE:
