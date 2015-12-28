############################################################################################################################
# Development Helpers
############################################################################################################################

export MAKEFLAGS="-j `nproc`"
export EDITOR=nvim
export TERMINAL=termite

if [ -d "$HOME/Code/golang/go" ]; then
	export GOROOT=$HOME/Code/golang/go
else
	export GOROOT=/usr/lib/go
fi

export GOPATH=$HOME/Code/gopkgs
export PATH=$PATH:$GOPATH/bin

export KUBERNETES_PROVIDER=azure
export KUBE_RELEASE_RUN_TESTS=n

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export PROMPT_DIRTRIM=2

# use_python27 will ensure that running `python` runs python2.7
use_python27() {
	local tmpdir=$(mktemp -d)
	ln -s "/usr/bin/python2.7" "${tmpdir}/python"
	export PATH="${tmpdir}:$PATH"
}

mitmproxy_prep() {
	cert_src="$HOME/.mitmproxy/mitmproxy-ca-cert.cer"
	cert_dest="/etc/ca-certificates/trust-source/anchors/mitmproxy-ca-cert.cer"

	if [[ ! -f "${cert_src}" ]]; then
		echo "must run mitmproxy for a few seconds"
		timeout 5 mitmproxy
		return
	fi
		
	sudo cp "${cert_src}" "${cert_dest}"
	sudo trust extract-compat

	local proxy="http://localhost:8080"
	echo "export HTTPS_PROXY=\"${proxy}\""
	echo "export https_proxy=\"${proxy}\""
}

github_add_publickey() {
	local date=`date`
	local hostname=`hostname`
	echo "enter username: "; read username
	echo "enter password: "; read password
	echo "enter otp: ";      read otp
	local sshPublicKeyData="$(cat $HOME/.ssh/id_rsa.pub)"
	curl \
		-u "$username:$password" \
		-H "X-GitHub-OTP: $otp" \
		--data "{\"title\": \"$hostname - $date\",\"key\":\"$sshPublicKeyData\"}" \
		https://api.github.com/user/keys
}

# ensure that we have vim-plug installed ahead of time
if [[ ! -f "$HOME/.config/nvim/autoload/plug.vim" ]]; then
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

rp() {
	local tempfile=$(mktemp)
	local wait_interval="$1"
	shift 1
	while true; do
		"$@" >$tempfile 2>&1
		clear
		date
		echo
		cat $tempfile
		sleep $wait_interval
	done
}

update_go_utils() {
	export GOPATH=$HOME/Code/gopkgs
	go get -u github.com/nsf/gocode
	go get -u github.com/golang/lint/golint
	go get -u github.com/Masterminds/glide
}


############################################################################################################################
# Generic Helpers
############################################################################################################################

docker_clean() { docker rm `docker ps --no-trunc -aq` }
dusummary() { sudo du -h / | sort -hr > $HOME/du.txt }
up() { sudo true; yaourt -Syua --noconfirm }
nixup() { /$HOME/Code/colemickens/yarn/nix-update.sh }

pacman_clean() { sudo pacman -Sc; sudo pacman -Scc; }

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

ssh_chimera_remote()  { ssh  cole@mickens.io    -p 222  }
ssh_chimera_local()   { ssh  cole@chimera.local -p 222  }
ssh_nucleus_remote()  { ssh  cole@mickens.io    -p 223  }
ssh_nucleus_local()   { ssh  cole@nucleus.local -p 223  }
ssh_pixel_local()     { ssh  cole@pixel.local   -p 224  }
mosh_chimera_remote() { mosh cole@mickens.io    --ssh="ssh -p 222" }
mosh_chimera_local()  { mosh cole@chimera.local --ssh="ssh -p 222" }
mosh_nucleus_remote() { mosh cole@mickens.io    --ssh="ssh -p 223" -p 61000:61999 }
mosh_nucleus_local()  { mosh cole@nucleus.local --ssh="ssh -p 223" -p 61000:61999 }
socks_chimera() { autossh -N -T -M 20000 -D1080 cole@mickens.io -N -p 222 }

proxy_rev_pixel() { autossh -N -T -M 20020 -R 22400:localhost:224 cole@mickens.io -p 222 }
proxy_fwd_pixel() { autossh -N -T -M 20030 -L 22400:localhost:22400 cole@mickens.io -p 222 }


############################################################################################################################
# RDP Helpers
############################################################################################################################

rdp_common() {
	set +x
	local rdpserver=$1
	local rdpuser=$2
	local rdppass=$3
	shift 3
	local customfreerdp=$HOME/Code/colemickens/FreeRDP/build/client/X11/xfreerdp

	local freerdp_bin=`which xfreerdp`
	if [ -f $customfreerdp ]; then
		freerdp_bin=$customfreerdp
	fi

	local -A rdpopts
	rdpopts[nucleus]="/size:2560x1405"
	rdpopts[pixel]="/size:2560x1650 /scale-device:140 /scale-desktop:140"
	rdpopts[cmcrbn]="/size:1910x1100"
	rdpopts[cmz420]="/size:1920x1145"

	# timeout 10 rdesktop $rdpserver

	$freerdp_bin \
		/cert-ignore \
		/v:$rdpserver \
		/u:$rdpuser \
		/p:$rdppass \
		$rdpopts[$(hostname)] \
		+fonts \
		+compression \
		+toggle-fullscreen \
		-wallpaper \
		"$@"
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

dpaste() {
	local content
	if read -t 0; then
		content=$(</dev/stdin)
	else
		content="$(cat "$1")"
	fi
	curl -F "content=$content" https://dpaste.de/api/?format=url
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
		if [[ $group == kube* ]]; then
			azure group delete --quiet "${group}"
		fi
	done
}

agd_all() {
	kubergs=($(azure group list --json | jq -r '.[].name' -))
	agd ${kubergs}
}


############################################################################################################################
# Golang Helpers
############################################################################################################################

gocovpkg() {
	time go test -coverprofile cover.out . \
	&& go tool cover -html=cover.out -o cover.html \
	&& echo firefox file:///`pwd`/cover.html \
	&& firefox file:///`pwd`/cover.html \
	&& rm cover.out cover.html
}

cd_kube() {
	export GOPATH=$HOME/Code/colemickens/kubernetes_gopath
	export PATH=$PATH:$GOPATH/bin
	export GO15VENDOREXPERIMENT=0
	cd $GOPATH/src/k8s.io/kubernetes
}
cd_azuresdk() {
	export GOPATH=$HOME/Code/colemickens/azure-sdk-for-go_gopath
	export PATH=$PATH:$GOPATH/bin
	export GO15VENDOREXPERIMENT=0
	cd $GOPATH/src/github.com/Azure/azure-sdk-for-go
}
cd_autorest() {
	export GOPATH=$HOME/Code/colemickens/go-autorest_gopath
	export PATH=$PATH:$GOPATH/bin
	export GO15VENDOREXPERIMENT=0
	cd $GOPATH/src/github.com/Azure/go-autorest
}
cd_azkube-kvbs() {
	export GOPATH=$HOME/Code/colemickens/azkube-kvbs_gopath
	export PATH=$PATH:$GOPATH/bin
	export GO15VENDOREXPERIMENT=1
	cd $GOPATH/src/github.com/colemickens/azkube-kvbs
}
cd_azkube() {
	export GOPATH=$HOME/Code/colemickens/azkube_gopath
	export PATH=$PATH:$GOPATH/bin
	export GO15VENDOREXPERIMENT=1
	cd $GOPATH/src/github.com/colemickens/azkube
}
cd_nginx-sso-persona() {
	export GOPATH=$HOME/Code/colemickens/nginx-sso-persona_gopath
	export PATH=$PATH:$GOPATH/bin
	export GO15VENDOREXPERIMENT=1
	cd $GOPATH/src/github.com/colemickens/nginx-sso-persona
}
cd_nginx-sso-twitter() {
	export GOPATH=$HOME/Code/colemickens/nginx-sso-twitter_gopath
	export PATH=$PATH:$GOPATH/bin
	export GO15VENDOREXPERIMENT=1
	cd $GOPATH/src/github.com/colemickens/nginx-sso-twitter
}


############################################################################################################################
# Work Helpers
############################################################################################################################

rdp_colemick10() {
	source $HOME/Dropbox/.secrets
	rdp_common 192.168.122.251 $COLEMICK10_USERNAME $COLEMICK10_PASSWORD
}

rdp_cmcrbn() {
	source $HOME/Dropbox/.secrets
	rdp_common cmcrbn.redmond.corp.microsoft.com $COLEMICK10_USERNAME $COLEMICK10_PASSWORD
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

############################################################################################################################
# Firefox Crap (until I find a better place for it)
############################################################################################################################

# loop.enabled = false
# browser.pocket.enabled = false
# browser.toolbarbuttons.introduced.pocket-button = false
#
