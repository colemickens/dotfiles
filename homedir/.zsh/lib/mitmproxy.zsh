mitmproxy() {
	# make sure the secret is here from dropbox, use it in args to mitmproxy
	#/usr/bin/env mitmproxy -b 127.0.0.1 -p 7777 "$@"
	/usr/bin/env mitmproxy -p 7777 "$@"
}

mitm_install_cert() {
	set -x
	sudo mkdir -p /usr/local/share/ca-certificates
	sudo cp ~/.mitmproxy/mitmproxy-ca-cert.cer /usr/local/share/ca-certificates/mitmproxy-ca-cert.crt
	sudo cp ~/.mitmproxy/mitmproxy-ca-cert.cer /etc/ca-certificates/trust-source/anchors/
	sudo trust extract-compat
	#sudo dpkg-reconfigure ca-certificates
}
