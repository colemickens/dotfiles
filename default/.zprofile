############################################################################################################################
# Development Helpers
############################################################################################################################

export MAKEFLAGS="-j 8"
export EDITOR=vim

if [ -d "$HOME/Code/golang/go" ]; then
	export GOROOT=$HOME/Code/golang/go
else
	export GOROOT=/usr/lib/go
fi

export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/Code/gopkgs
export PATH=$PATH:$GOPATH/bin

export KUBERNETES_PROVIDER=azure
export KUBE_RELEASE_RUN_TESTS=n

# over path to my list of overrides (python->python2.7 on Arch, for example)
pathoverride() {
	if [ -d "/home/cole/Code/pathoverride" ]; then
		export PATH=/home/cole/Code/pathoverride/:$PATH
	else
		echo "pathoverride dir doesn't exist"
		return -1
	fi
}

mitmproxy_prep() {
	cert_src="$HOME/.mitmproxy/mitmproxy-ca-cert.cer"
	cert_dest="/etc/ca-certificates/trust-source/anchors/mitmproxy-ca-cert.cer"

	if [[ ! -f "${cert_dest}" ]]; then
		echo "mitmproxy cert hasn't been installed yet"
		if [[ ! -f "${cert_src}" ]]; then
			echo "mitmproxy hasn't generated certs yet. run \`mitmproxy\` and then try again"
			exit -1
		fi
		
		sudo cp "${cert_src}" "${cert_dest}"
		sudo trust extract-compat
	fi

	local proxy="https://localhost:8080"
	export HTTPS_PROXY="${proxy}"
	export https_proxy="${proxy}"
}

############################################################################################################################
# Generic Helpers
############################################################################################################################

clean_docker() { docker rm `docker ps --no-trunc -aq` }
dusummary() { sudo du -h / | sort -hr > $HOME/du.txt }
up() { yaourt -Syua --noconfirm }

videomodeset() {
	windowid=$(xwininfo -int | grep "Window id" | awk '{ print $4 }')
	python2.7 $HOME/.scripts/change-window-borders.py ${windowid} 0
	wmctrl -i -r ${windowid} -b add,above
}

videomodeunset() {
	windowid=$(xwininfo -int | grep "Window id" | awk '{ print $4 }')
	python2.7 $HOME/.scripts/change-window-borders.py ${windowid} 1
	wmctrl -i -r ${windowid} -b remove,above
}

############################################################################################################################
# SSH Helpers
############################################################################################################################

ssh_chimera_remote()  { ssh  cole@mickens.io -p 222  }
ssh_chimera_local()   { ssh  cole@10.0.0.2   -p 222  }
ssh_nucleus_remote()  { ssh  cole@mickens.io -p 223 }
ssh_nucleus_local()   { ssh  cole@10.0.0.3   -p 223  }
mosh_chimera_remote() { mosh cole@mickens.io --ssh="ssh -p 222" }
mosh_chimera_local()  { mosh cole@10.0.0.2   --ssh="ssh -p 222" }
mosh_nucleus_remote() { mosh cole@mickens.io --ssh="ssh -p 223" -p 61000:61999 }
mosh_nucleus_local()  { mosh cole@10.0.0.3   --ssh="ssh -p 223" -p 61000:61999 }
socks_chimera() { autossh -N -T -M 20000 -D1080 cole@mickens.io -N -p 222 }
socks_nucleus() { autossh -N -T -M 20010 -D1080 cole@mickens.io -N -p 223 }

reverseProxy() { autossh -N -T -M 20020 -R 22022:localhost:22 cole@mickens.io -p 222 }
reverseProxyClient() { autossh -N -T -M 20030 -L 22022:localhost:22022 cole@mickens.io -p 222 }

reverseProxyWin() { autossh -N -T -M 20040 -R 33890:192.168.122.251:3389 cole@mickens.io -p 222 }
reverseProxyWinClient() { autossh -N -T -M 20050 -L 33890:localhost:33890 cole@mickens.io -p 222 }


############################################################################################################################
# RDP Helpers
############################################################################################################################

rdp_common() {
	local rdpserver=$1
	local rdpuser=$2
	local rdppass=$3
	local customfreerdp=$HOME/Code/colemickens/FreeRDP/build/client/X11/xfreerdp

	local freerdp_bin=`which xfreerdp`
	if [ -f $customfreerdp ]; then
		freerdp_bin=$customfreerdp
	fi

	local -A rdpopts
	rdpopts[nucleus]="/size:2560x1405"
	rdpopts[pixel]="/size:2560x1650 /scale-device:140 /scale-desktop:140"
	rdpopts[colemick-carbon]="/size:1910x1100"
	rdpopts[colemick-z420]="/size:1920x1170"

	local rdpoptions=$rdpopts[$(hostname)]

	$freerdp_bin \
		/cert-ignore \
		/v:$rdpserver \
		/u:$rdpuser \
		/p:$rdppass \
		$rdpoptions \
		+fonts \
		+compression \
		+toggle-fullscreen \
		-wallpaper
}


############################################################################################################################
# Screen Capture Helpers
############################################################################################################################

take_screenshot() {
	# can call as `take_screenshot -s` to do a selection
	mkdir -p ~/tmp/screenshots;
	FILENAME=screenshot-`date +%Y-%m-%d-%H%M%S`.png;
	FILEPATH=$HOME/tmp/screenshots/$FILENAME;
	scrot $1 $FILEPATH;
	echo $FILEPATH;
}

take_screencast() {
	mkdir -p ~/tmp/screencasts;
	FILENAME=screencast-`date +%Y-%m-%d-%H%M%S`.mkv;
	FILEPATH=$HOME/tmp/screencasts/$FILENAME
	eval $(slop);
	ffmpeg -f x11grab -s "$W"x"$H" -i :0.0+$X,$Y $FILEPATH >/dev/null 2>&1;
	echo $FILEPATH;
}

take_screencast_full() {
	echo "test"
	mkdir -p ~/tmp/screencasts;
	FILENAME=screencast-`date +%Y-%m-%d-%H%M%S`.mkv;
	FILEPATH=$HOME/tmp/screencasts/$FILENAME
	FULLSCREEN=$(xwininfo -root | grep 'geometry' | awk '{print $2;}')

	echo "ffmpeg -f x11grab -s $FULLSCREEN $FILEPATH # >/dev/null 2>&1;"

	ffmpeg -f x11grab -s $FULLSCREEN $FILEPATH # >/dev/null 2>&1;
	echo $FILEPATH;
}

upload_to_s3_screenshots() {
	FILEPATH=$1
	FILENAME=$(basename $FILEPATH)

	source ~/Dropbox/.secrets
	aws s3 cp --acl=public-read $FILEPATH s3://colemickens-screenshots/ >/dev/null 2>&1;
	echo "https://colemickens-screenshots.s3.amazonaws.com/$FILENAME"
}


############################################################################################################################
# Sysadmin Stuff
############################################################################################################################

backup_code() {
	FILENAME=colemickens-Code-`hostname`-backup-`date +%Y-%m-%d-%H%M%S`.tar.gz
	FILEPATH=$HOME/$FILENAME

	tar -czf $FILENAME ~/Code/colemickens
	echo $FILENAME: `du -hs $FILEPATH`

	source ~/Dropbox/.secrets
	aws s3 cp $FILENAME s3://colemickens-backups/$FILENAME
	echo "https://colemickens-screenshots.s3.amazonaws.com/$FILENAME"
}

reflector_run() {
	sudo true
	wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
	&& reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
	&& sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
	&& sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}


############################################################################################################################
# Dual boot helpers (nucleus)
############################################################################################################################

if [ `hostname` = "nucleus" ]; then
	reboot_windows_once() {
		BOOTNEXTNUM=`efibootmgr | grep Windows\ Boot\ Manager | sed -n 's/.*Boot\([0-9a-f]\{4\}\).*/\1/p'`
		sudo efibootmgr --bootnext $BOOTNEXTNUM
		sleep 3; sudo reboot
	}

	reboot_windows_permanently() {
		BOOTWINDOWSNUM=`efibootmgr | grep Windows\ Boot\ Manager | sed -n 's/.*Boot\([0-9a-f]\{4\}\).*/\1/p'`
		BOOTLINUXNUM=`efibootmgr | grep Linux\ Boot\ Manager | sed -n 's/.*Boot\([0-9a-f]\{4\}\).*/\1/p'`
		echo sudo efibootmgr --bootorder $BOOTWINDOWSNUM,$BOOTLINUXNUM
		sudo efibootmgr --bootorder $BOOTWINDOWSNUM,$BOOTLINUXNUM
		sleep 3; sudo reboot
	}

	reboot_linux_permanently() {
		BOOTWINDOWSNUM=`efibootmgr | grep Windows\ Boot\ Manager | sed -n 's/.*Boot\([0-9a-f]\{4\}\).*/\1/p'`
		BOOTLINUXNUM=`efibootmgr | grep Linux\ Boot\ Manager | sed -n 's/.*Boot\([0-9a-f]\{4\}\).*/\1/p'`
		echo sudo efibootmgr --bootorder $BOOTLINUXNUM,$BOOTWINDOWSNUM
		sudo efibootmgr --bootorder $BOOTLINUXNUM,$BOOTWINDOWSNUM
		sleep 3; sudo reboot
	}

	reboot_linux_once() {
		BOOTNEXTNUM=`efibootmgr | grep Linux\ Boot\ Manager | sed -n 's/.*Boot\([0-9a-f]\{4\}\).*/\1/p'`
		sudo efibootmgr --bootnext $BOOTNEXTNUM
		sleep 3; sudo reboot
	}
fi


############################################################################################################################
# Kubernetes Helpers
############################################################################################################################

agd() {
	for group in ${@}; do
		azure group delete --quiet "${group}"
	done
}

agd_all() {
	kubergs=($(azure group list --json | jq -r '.[].name' -))
	agd ${kubergs}
}


############################################################################################################################
# Golang Helpers
############################################################################################################################

gocovpkg() { time go test -coverprofile cover.out . && go tool cover --html cover.out && rm cover.out }

cd_kube() {
	export GOPATH=$HOME/Code/colemickens/kubernetes_gopath
	cd $GOPATH/src/k8s.io/kubernetes
}
cd_azuresdk() {
	export GOPATH=$HOME/Code/colemickens/azure-sdk-for-go_gopath
	cd $GOPATH/src/github.com/Azure/azure-sdk-for-go
}
cd_autorest() {
	export GOPATH=$HOME/Code/colemickens/go-autorest_gopath
	cd $GOPATH/src/github.com/Azure/go-autorest
}

############################################################################################################################
# Work Helpers
############################################################################################################################

rdp_colemick10() {
	source $HOME/Dropbox/.secrets
	rdp_common 192.168.122.251 $COLEMICK10_USERNAME $COLEMICK10_PASSWORD
}

rdp_colemick10_remote() {
	source $HOME/Dropbox/.secrets
	rdp_common localhost:33890 $COLEMICK10_USERNAME $COLEMICK10_PASSWORD
}


############################################################################################################################
# DNVM Helpers
############################################################################################################################

if [[ -f "/home/cole/.dnx/dnvm/dnvm.sh" ]]; then
	source "/home/cole/.dnx/dnvm/dnvm.sh"
fi
