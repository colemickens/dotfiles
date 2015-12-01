personal: FORCE
	mkdir -p ~/.config
	mkdir -p ~/.config/hexchat
	mkdir -p ~/.config/autostart
	mkdir -p ~/.config/nvim
	stow default --no-folding -t ~/
	stow personal --no-folding -t ~/

work: FORCE
	stow default --no-folding -t ~/
	stow work --no-folding -t ~/

server: FORCE
	sudo stow server --no-folding -t /
	sudo mkdir /etc/openvpn
	sudo mkdir /etc/nginx
	sudo mkdir /etc/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl restart nginx
	sudo systemctl restart cloudflare-dyndns
	sudo systemctl restart ssoauth

FORCE:
