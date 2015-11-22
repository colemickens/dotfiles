basic:
	mkdir -p ~/.config

personal: FORCE
	stow default -t ~/
	stow personal -t ~/

work: FORCE
	stow default -t ~/
	stow work -t ~/

server: FORCE
	sudo stow server -t /
	sudo systemctl daemon-reload
	sudo systemctl restart nginx
	sudo systemctl restart cloudflare-dyndns
	sudo systemctl restart ssoauth

FORCE: basic
