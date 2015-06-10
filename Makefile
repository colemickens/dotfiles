all:
	stow default -t ~/

server: FORCE
	sudo stow server -t /

FORCE:
