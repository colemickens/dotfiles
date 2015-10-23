personal: FORCE
	stow default -t ~/
	stow personal -t ~/

server: FORCE
	sudo stow server -t /

FORCE:
