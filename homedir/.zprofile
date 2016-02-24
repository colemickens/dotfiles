#############################################################################################################################
# Generic Stuff
#############################################################################################################################

export MAKEFLAGS="-j `nproc`"
export EDITOR="nvim"
export BROWSER="chromium"
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export TERMINAL="termite"
export DISTRO="$(source /etc/os-release; echo "$ID")"
export PATH=$PATH:$HOME/bin

myip() {
	txt="$(dig o-o.myaddr.l.google.com @ns1.google.com txt +short)"
	echo ${txt//\"}
}

gitup() {
	for p in $HOME/code/* ; do
		if [[ -d "$p" ]]; then
			for d in $p/* ; do
				(
					cd "$d"
					echo
					echo "---- updating $d"
					git remote update --prune
					git status
				)
			done
		fi
	done
}

gotty_wrap() {
	set -x
	gotty --address 0.0.0.0 --port "5050" tmux new-session -A -s gotty
}

countdown() {
   date1=$((`date +%s` + $1));
   while [ "$date1" -ge `date +%s` ]; do
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}

stopwatch() {
  date1=`date +%s`;
   while true; do
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
   done
}

############################################################################################################################
# NixOS
############################################################################################################################

if [[ "$DISTRO" == "nixos" ]]; then
	nixup() {
		(
			d="$(mktemp -d)"
			cd "$d"
			sudo nixos-rebuild --keep-going -I / switch
		)
	}
	nixup-build-master() {
		device="$1"
		nixosConfig="/nixcfg/devices/$device/default.nix"
		nixpkgs="/nixpkgs-master"
		logfile="$(mktemp "/tmp/nixup-build-master-$device-XXX.log")"
		echo "device($device) build log: ($logfile)"
		(
			export NIX_PATH="nixos-config=$nixosConfig:nixpkgs=$nixpkgs"
			nix-build '<nixpkgs/nixos>' -A "config.system.build.toplevel" --keep-going -I "nixos-config=$nixosConfig" >>"$logfile" 2>&1
		)
	}
	nixupall() {
		# replace this with a jenkins job once I setup jenkins (with the other skin and the declarative plugin)
		nixup-build-master chimera
		nixup-build-master nucleus
		nixup-build-master pixel
	}
	nixgc() {
		nix-env --delete-generations old
		nix-collect-garbage
		nix-collect-garbage -d
		sudo nix-env --delete-generations old
		sudo nix-collect-garbage
		sudo nix-collect-garbage -d
	}
	nixazurevhd() {
		NIXOS_CONFIG=/nixpkgs/nixos/modules/virtualisation/azure-image.nix \
		NIX_PATH=/ \
			nix-build '<nixpkgs/nixos>' \
				-A config.system.build.azureImage \
				--argstr system x86_64-linux \
				-o azure \
				--option extra-binary-caches https://hydra.nixos.org \
				-j 4
	}
fi


############################################################################################################################
# Arch
############################################################################################################################

if [[ "$DISTRO" == "arch" ]]; then
	archup() { sudo true; yaourt -Syua --noconfirm }
	pacman_clean() { sudo pacman -Sc; sudo pacman -Scc; }

	reflector_run() {
		sudo true
		wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
		&& reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
		&& sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
		&& sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
	}
fi


############################################################################################################################
# Development Helpers
############################################################################################################################

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
	echo "enter otp: ";	  read otp
	local sshPublicKeyData="$(cat $HOME/.ssh/id_rsa.pub)"
	curl \
		-u "$username:$password" \
		-H "X-GitHub-OTP: $otp" \
		--data "{\"title\": \"$hostname - $date\",\"key\":\"$sshPublicKeyData\"}" \
		https://api.github.com/user/keys
}


############################################################################################################################
# Launcher Helpers
############################################################################################################################

orbment() {
	export WLC_DIM=0.9
	/usr/bin/env orbment
}

mitmproxy() {
	# make sure the secret is here from dropbox, use it in args to mitmproxy
	/usr/bin/env mitmproxy --cadir /secrets/mitmproxy "$@"
}


############################################################################################################################
# Generic Helpers
############################################################################################################################

docker_clean() { docker rm `docker ps --no-trunc -aq` }
du_summary() { sudo du -x -h / | sort -hr > $HOME/du_summary.txt }

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

ssh_chimera_remote()	{ ssh  cole@mickens.io		-p 222 }
ssh_chimera_local()		{ ssh  cole@chimera.local	-p 222 }
ssh_nucleus_remote()	{ ssh  cole@mickens.io		-p 223 }
ssh_nucleus_local()		{ ssh  cole@nucleus.local	-p 223 }
ssh_pixel_local()		{ ssh  cole@pixel.local		-p 224 }
mosh_chimera_remote()	{ mosh cole@mickens.io		--ssh="ssh -p 222" }
mosh_chimera_local()	{ mosh cole@chimera.local	--ssh="ssh -p 222" }
mosh_nucleus_remote()	{ mosh cole@mickens.io		--ssh="ssh -p 223" -p 61000:61999 }
mosh_nucleus_local()	{ mosh cole@nucleus.local	--ssh="ssh -p 223" -p 61000:61999 }
socks_chimera() { autossh -N -T -M 20000 -D1080 cole@mickens.io -N -p 222 }

proxy_rev_pixel() { autossh -N -T -M 20020 -R 22400:localhost:224 cole@mickens.io -p 222 }
proxy_fwd_pixel() { autossh -N -T -M 20030 -L 22400:localhost:22400 cole@mickens.io -p 222 }


############################################################################################################################
# RDP Helpers
############################################################################################################################

rdp_common() {
	set -x
	local rdpserver=$1
	local rdpuser=$2
	local rdppass=$3
	shift 3
	local customfreerdp=$HOME/code/colemickens/FreeRDP/build/client/X11/xfreerdp

	local freerdp_bin=`which xfreerdp`
	if [ -f $customfreerdp ]; then
		echo "using custom build"
		freerdp_bin=$customfreerdp
	fi

	local -A rdpopts
	rdpopts[nucleus]="/size:2560x1405"
	rdpopts[pixel]="/scale:140 /size:2560x1650" # this doesn't work, doesnt expand right below
	rdpopts[cmcrbn]="/size:1910x1100"
	rdpopts[cmz420]="/size:1920x1160"

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
	source $HOME/Dropbox/.secrets/cmcrbn_credentials
	rdp_common cmcrbn.redmond.corp.microsoft.com $COLEMICK10_USERNAME $COLEMICK10_PASSWORD
}

rdp_winvm04() {
	source $HOME/Dropbox/.secrets/winvm04_credentials
	rdp_common 191.232.32.221 "$WINVM04_USERNAME" "$WINVM04_PASSWORD"
}

rdp_winvm() {
	source $HOME/Dropbox/.secrets/winvm04_credentials
	rdp_common 191.232.38.190 "$WINVM04_USERNAME" "$WINVM04_PASSWORD"
}


############################################################################################################################
# Screen Capture Helpers
############################################################################################################################

take_screenshot() {
	set -x
	# can call as `take_screenshot -s` to do a selection
	mkdir -p ~/tmp/screenshots;
	FILENAME=screenshot-`date +%Y-%m-%d-%H%M%S`.png;
	FILEPATH=$HOME/tmp/screenshots/$FILENAME;
	scrot $1 $FILEPATH;
	echo $FILEPATH;
}

take_screencast() {
	set -x
	mkdir -p ~/tmp/screencasts;
	FILENAME=screencast-`date +%Y-%m-%d-%H%M%S`.mkv;
	FILEPATH=$HOME/tmp/screencasts/$FILENAME
	eval $(slop);
	ffmpeg -f x11grab -s "$W"x"$H" -i ${DISPLAY}+$X,$Y $FILEPATH >/dev/null 2>&1;
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


############################################################################################################################
# backups
############################################################################################################################

s3_upload() {
	source /secrets/aws_credentials
	FILEPATH="$1"
	FILENAME=$(basename $FILEPATH)
	BUCKET="$2"
	aws s3 cp --acl=public-read $FILEPATH s3://$BUCKET/$FILENAME >/dev/null 2>&1;
	echo "https://$BUCKET.s3.amazonaws.com/$FILENAME"
}

s3_random() {
	FILEPATH="$1"
	BUCKET="colemickens-random"
	s3_upload "$FILEPATH" "$BUCKET"
}

s3_screenshots() {
	FILEPATH="$1"
	BUCKET="colemickens-random"
	s3_upload "$FILEPATH" "$BUCKET"
}

backup_code() {
	FILENAME=colemickens-code`hostname`-backup-`date +%Y-%m-%d-%H%M%S`.tar.gz
	FILEPATH=$HOME/$FILENAME

	tar -czf $FILENAME ~/code/colemickens
	echo $FILENAME: `du -hs $FILEPATH`

	source ~/Dropbox/.secrets
	aws s3 cp $FILENAME s3://colemickens-backups/$FILENAME
	echo "https://colemickens-screenshots.s3.amazonaws.com/$FILENAME"
}


#############################################################################################################################
# pixel helpers
#############################################################################################################################

if [ `hostname` = "pixel" ]; then
	touchpad_reset() {
		sudo modprobe i2c-dev
		echo -ne 'r\nq\n' | sudo mxt-app -d i2c-dev:{7,8}-004a
	}

	sound_reset() {
		cd /nix/store/jcni323n5srjjacpadvrmjmd18yp77f6-linux-samus-eb4bb50-src/scripts/setup/sound
		pulseaudio -k
		sudo alsactl restore --file alsa/speakers.state
	}
fi


############################################################################################################################
# nucleus helpers
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

export KUBERNETES_PROVIDER=azure
export KUBE_RELEASE_RUN_TESTS=n


############################################################################################################################
# Azure Helpers
############################################################################################################################

az_cli() {
	docker run -it -v $HOME/.az:/root/.azure az-cli /bin/bash
}

agd() {
	for group in ${@}; do
		if [[ $group == * ]]; then
			echo "deleting ${group}"
			#azure group delete --quiet "${group}"
		else
			echo "skipping ${group}"
		fi
	done
}

agd_all() {
	acct="$(azure account show)"
	contains="$(echo "$acct" | grep "aff271ee-e9be-4441-b9bb-42f5af4cbaeb")"
	if [[ -z "${contains}" ]]; then
		echo "wrong subscription"
		return
	fi
	rgs=($(azure group list --json | jq -r '.[].name' -))
	agd ${rgs}
}


############################################################################################################################
# Golang Stuff
############################################################################################################################

export GOPATH=$HOME/code/gopkgs
export PATH=$PATH:$GOPATH/bin

gocovpkg() {
	time go test -coverprofile cover.out . \
	&& go tool cover -html=cover.out -o cover.html \
	&& echo firefox file:///`pwd`/cover.html \
	&& firefox file:///`pwd`/cover.html \
	&& rm cover.out cover.html
}

gopath() {
	OWNER="$1"
	REPO="$2"
	IMPORTPATH="$3"
	export GOPATH="${HOME}/code/${OWNER}/${REPO}_gopath"
	export PATH="${PATH}:${GOPATH}/bin"
	export GO15VENDOREXPERIMENT=1

	cd "${GOPATH}/src/${IMPORTPATH}"
}

cd_autorest() { gopath azure autorest github.com/Azure/go-autorest }
cd_azkube() { gopath azure azkube github.com/colemickens/azkube }
cd_azuresdk() { gopath azure azuresdk github.com/Azure/azure-sdk-for-go }
cd_kubernetes() { gopath azure kubernetes github.com/kubernetes/kubernetes }
cd_asciinema() { gopath colemickens asciinema github.com/asciinema/asciinema }

# these are things that vim-go needs, or we otherwise use (glide)
go_update_utils() {
	export GOPATH=$HOME/code/gopkgs

	go get -u golang.org/x/tools/cmd/goimports # vim-go
	go get -u golang.org/x/tools/cmd/oracle # vim-go
	go get -u golang.org/x/tools/cmd/gorename # vim-go

	go get -u github.com/nsf/gocode # vim-go
	go get -u github.com/rogpeppe/godef # vim-go
	go get -u github.com/alecthomas/gometalinter # vim-go
	go get -u github.com/golang/lint/golint # vim-go
	go get -u github.com/kisielk/errcheck # vim-go
	go get -u github.com/jstemmer/gotags # vim -go

	go get -u github.com/golang/lint/golint
	go get -u github.com/Masterminds/glide
}

