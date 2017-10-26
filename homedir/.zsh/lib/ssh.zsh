assh() {
	autossh -M 0 "$@" -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2"
}

autossh_chimera()	{ assh	cole@chimera.mickens.io -p 222 }
ssh_chimera()		{ ssh	cole@chimera.mickens.io -p 222 }
mosh_chimera()		{ mosh	cole@chimera.mickens.io	--ssh="ssh -p 222" }

socks_chimera() { set -x; ssh -v -D 1080 -C -q -N cole@chimera.mickens.io -p 222 }

proxy_chimera_rev() { assh cole@chimera.mickens.io -p 222 -N -T -R 2222:localhost:${1} }
proxy_chimera_fwd() { assh cole@chimera.mickens.io -p 222 -N -T -L 2222:localhost:2222 }
proxy_connect() { assh cole@localhost -p 2222 }

sshuttle_chimera() { sshuttle -r cole@chimera.mickens.io:222 '0.0.0.0/0' }

sshfs_chimera() {
	mkdir -p $HOME/chimera_sshfs
	sshfs cole@chimera.mickens.io:/home/cole $HOME/chimera_sshfs -C -p222
}
