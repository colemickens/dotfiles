assh() {
	autossh -M 0 "$@" -o "ServerAliveInterval 45" -o "ServerAliveCountMax 2"
}

autossh_chimera_remote()	{ assh	cole@mickens.io			-p 222 }
autossh_chimera_local()		{ assh	cole@chimera.local		-p 222 }
autossh_azdev()				{ assh	cole@azdev.mickens.io	-p 22 }
ssh_chimera_remote()		{ ssh	cole@mickens.io			-p 222 }
ssh_chimera_local()			{ ssh	cole@chimera.local		-p 222 }
ssh_azdev()					{ ssh	cole@azdev.mickens.io	-p 22 }
mosh_chimera_remote()		{ mosh	cole@chimera.mickens.io	--ssh="ssh -p 222" }
mosh_chimera_local()		{ mosh	cole@chimera.local		--ssh="ssh -p 222" }
mosh_azdev()				{ mosh	cole@azdev.mickens.io	}

proxy_chimera_rev() { assh cole@chimera.mickens.io -p 222 -N -T -R 2222:localhost:${1} }
proxy_chimera_fwd() { assh cole@chimera.mickens.io -p 222 -N -T -L 2222:localhost:2222 }
proxy_connect() { assh cole@localhost -p 2222 }

sshuttle_chimera() { sshuttle -r cole@mickens.io:222 '0.0.0.0/0' }
