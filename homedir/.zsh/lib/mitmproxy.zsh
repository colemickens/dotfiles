mitm() {
	# make sure the secret is here from dropbox, use it in args to mitmproxy
	/usr/bin/env mitmproxy -b 127.0.0.1 -p 9000 "$@"
}

mitm_install_cert() {
	sudo mkdir /usr/local/share/ca-certificates
	sudo cp ~/.mitmproxy/mitmproxy-ca-cert.cer /usr/local/share/ca-certificates/mitmproxy-ca-cert.crt
	sudo dpkg-reconfigure ca-certificates
}
