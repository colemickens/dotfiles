####
# Pixel Helpers
###

touchpad_reset() {
	sudo modprobe i2c-dev &>/dev/null
	echo -ne 'r\nq\n' | sudo mxt-app -d i2c-dev:{7,8}-004a &>/dev/null
}

############################################################################################################################
# Development Helpers
############################################################################################################################

export MAKEFLAGS="-j `nproc`"
export EDITOR=nvim

export PATH=$PATH:$GOPATH/bin

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export PROMPT_DIRTRIM=2

# use_python27 will ensure that running `python` runs python2.7
use_python27() {
	local tmpdir=$(mktemp -d)
	ln -s "/usr/bin/python2.7" "${tmpdir}/python"
	export PATH="${tmpdir}:$PATH"
}

# add a key to github with OTP code
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

mitmproxy_install_arch() {
	sudo cp ~/.mitmproxy/mitmproxy-ca-cert.cer /etc/ca-certificates/trust-source/anchors/mitmproxy-ca-cert.cer
	sudo trust extract-compat
}


############################################################################################################################
# Launcher Helpers
############################################################################################################################

orbment() {
	export WLC_DIM=0.9
	export TERMINAL=termite
	/usr/bin/env orbment
}


############################################################################################################################
# Generic Helpers
############################################################################################################################

docker_clean() { docker rm `docker ps --no-trunc -aq` }
du_summary() { sudo du -h / | sort -hr > $HOME/du.txt }
archup() { sudo true; yaourt -Syua --noconfirm }
nixup() { sudo nixos-rebuild -I / switch; }
nixgc() {
	nix-env --delete-generations old
	nix-collect-garbage
	nix-collect-garbage -d
	sudo nix-env --delete-generations old
	sudo nix-collect-garbage
	sudo nix-collect-garbage -d
}

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

rdp_cmcrbn() {
	source $HOME/Dropbox/.secrets
	rdp_common cmcrbn.redmond.corp.microsoft.com $COLEMICK10_USERNAME $COLEMICK10_PASSWORD
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
# Azure/Kubernetes Helpers
############################################################################################################################

export KUBERNETES_PROVIDER=azure
export KUBE_RELEASE_RUN_TESTS=n

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
# Golang Stuff
############################################################################################################################

export GOROOT=/usr/lib/go
export GOPATH=$HOME/Code/gopkgs
export PATH=$PATH:$GOPATH/bin

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
cd_azkube() {
	export GOPATH=$HOME/Code/colemickens/azkube_gopath
	export PATH=$PATH:$GOPATH/bin
	export GO15VENDOREXPERIMENT=1
	cd $GOPATH/src/github.com/colemickens/azkube
}

# these are things that vim-go needs, or we otherwise use (glide)
go_update_utils() {
	export GOPATH=$HOME/Code/gopkgs

	go get -u github.com/nsf/gocode # vim-go
	go get -u github.com/alecthomas/gometalinter # vim-go
	go get -u github.com/x/tools/cmd/goimports # vim-go
	go get -u github.com/rogpeppe/godef # vim-go
	go get -u github.com/x/tools/cmd/oracle # vim-go
	go get -u github.com/x/tools/cmd/gorename # vim-go
	go get -u github.com/golang/lint/golint # vim-go
	go get -u github.com/kisielk/errcheck # vim-go
	go get -u github.com/jstemmer/gotags # vim -go

	go get -u github.com/golang/lint/golint
	go get -u github.com/Masterminds/glide
}

