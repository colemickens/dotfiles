basic:
	mkdir -p ~/.config
	mkdir -p /etc/openvpn
	mkdir -p /etc/nginx
	mkdir -p /etc/systemd/system

personal: FORCE
	mkdir ~/.config
	mkdir ~/.config/hexchat
	mkdir ~/.config/autostart
	mkdir ~/.config/nvim
	stow default -t ~/
	stow personal -t ~/

work: FORCE
	stow default -t ~/
	stow work -t ~/

server: FORCE
	sudo stow server -t /
	sudo mkdir /etc/openvpn
	sudo mkdir /etc/nginx
	sudo mkdir /etc/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl restart nginx
	sudo systemctl restart cloudflare-dyndns
	sudo systemctl restart ssoauth

FORCE: basic
