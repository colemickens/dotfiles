assh() {
	autossh -M 0 "$@" -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2"
}

autossh_chimera_remote()	{ assh	cole@mickens.io			-p 222 }
autossh_chimera_local()		{ assh	cole@chimera.local		-p 222 }
autossh_azdev()				{ assh	cole@azdev.mickens.io	-p 22 }
ssh_chimera_remote()		{ ssh	cole@mickens.io			-p 222 }
ssh_chimera_local()			{ ssh	cole@chimera.local		-p 222 }
ssh_azdev()					{ ssh	cole@azdev.mickens.io	-p 22 }
mosh_chimera_remote()		{ mosh	cole@mickens.io			--ssh="ssh -p 222" }
mosh_chimera_local()		{ mosh	cole@chimera.local		--ssh="ssh -p 222" }
mosh_azdev()				{ mosh	cole@azdev.mickens.io	--ssh="ssh -p 22" }
mosh_azudev()				{ mosh	cole@azudev.mickens.io	--ssh="ssh -p 22" }

sshfs_common() {
	host="$1"
	location="$2"
	command sshfs -o reconnect,compression=yes,transform_symlinks,ServerAliveInterval=45,ServerAliveCountMax=2,ssh_command='autossh -M 0' cole@"$1":/home/cole "$2"
}


sshfs_azdev() { sshfs_common azdev.mickens.io ~/mnt/azdev }
sshfs_cmz420() { sshfs_common cmz420 ~/mnt/cmz420 }

unsshfs() {
	sudo diskutil unmount ~/mnt/azdev || true
	sudo diskutil unmount ~/mnt/chimera || true
	sudo diskutil unmount ~/mnt/cmz420 || true
}

proxy_chimera_rev() { assh cole@chimera.mickens.io -p 222 -N -T -R 2222:localhost:${1} }
proxy_chimera_fwd() { assh cole@chimera.mickens.io -p 222 -N -T -L 2222:localhost:2222 }
proxy_connect() { assh cole@localhost -p 2222 }
proxy_mac_socks_up() {
	networksetup -setsocksfirewallproxy Wi-Fi localhost 1080
	networksetup -setsocksfirewallproxystate Wi-Fi on
}
proxy_mac_socks_down() {
	networksetup -setsocksfirewallproxystate Wi-Fi off
}
proxy_socks() {
	if [[ "${PLATFORM_OS}" == "macos" ]]; then
		proxy_mac_socks_up
		assh cole@localhost -p 2222 -N -D1080
		proxy_mac_socks_down
	else
		assh cole@localhost -p 2222 -N -D1080
	fi
}

socks_chimera() { autossh -M 0 -p 222 -N -D 1080 -o "ServerAliveInterval 45" -o "ServiceAliveCountMax 2" cole@mickens.io }
sshuttle_chimera() { sshuttle -r cole@mickens.io:222 '0.0.0.0/0' }
