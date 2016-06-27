##############################################################################
# Environment Detection (used in ~/.zprofile as well)
##############################################################################
export HOSTNAME="$(hostname)"
export UNAMESTR="$(uname)"

export PLATFORM_OS="unknown"
export PLATFORM_DISTRO="unknown"
export PLATFORM_ARCH="unknown"
export NPROC=1

if [[ "${UNAMESTR}" == "Darwin" ]]; then
	export PLATFORM_OS="mac"
	export PLATFORM_DISTRO=""
	export PLATFORM_ARCH="amd64"
	export NPROC="$(sysctl -n hw.ncpu)"
elif [[ "${UNAMESTR}" == "Linux" ]]; then
	export PLATFORM_OS="linux"
	export PLATFORM_DISTRO="$(source /etc/os-release; echo "${ID}")"
	export PLATFORM_ARCH="amd64"
	export NPROC="$(nproc)"
fi


#############################################################################################################################
# Generic Stuff
#############################################################################################################################

# TODO: use autossh instead of ssh, especially for the remote connections

export MAKEFLAGS="-j ${NPROC}"
export EDITOR="nvim"
#export NVIM_TUI_ENABLE_TRUE_COLOR=1
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.local/bin

if [[ "${PLATFORM_OS}" == "linux" ]]; then
	export BROWSER="chromium"
	export TERMINAL="termite"
fi

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

gotty_wrap_w() {
	set -x
	gotty -w --address 0.0.0.0 --port "5050" tmux new-session -A -s gotty
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

md5sumb64() {
	openssl dgst -md5 -binary $1 | openssl enc -base64
}

############################################################################################################################
# NixOS
############################################################################################################################

if [[ "${PLATFORM_OS}" == "mac" ]]; then
	export NIX_PATH=nixpkgs=/nixpkgs
	nixload() {
		source /Users/cole/.nix-profile/etc/profile.d/nix.sh
	}
fi

if [[ "${PLATFORM_DISTRO}" == "nixos" ]]; then
	nixup() {
		(
			d="$(mktemp -d)"
			cd "$d"
			sudo nixos-rebuild --keep-going -I / switch
		)
	}
	nixup-build-device() {
		device="$1"
		nixosConfig="${HOME}/code/colemickens/dotfiles/nixcfg/devices/$device/default.nix"
		nixpkgs="/nixpkgs"
		logfile="$(mktemp "/tmp/nixup-build-master-$device-XXX.log")"
		echo "device($device) build log: ($logfile)"
		(
			export NIX_PATH="nixos-config=$nixosConfig:nixpkgs=$nixpkgs"
			nix-build '<nixpkgs/nixos>' -A "config.system.build.toplevel" --keep-going -I "nixos-config=$nixosConfig" >>"$logfile" 2>&1
		)
	}
	nixupall() {
		# replace this with a jenkins job once I setup jenkins (with the other skin and the declarative plugin)
		nixup-build-device chimera
		nixup-build-device nucleus
		nixup-build-device pixel
	}
	nixgc() {
		nix-env --delete-generations old
		nix-collect-garbage
		nix-collect-garbage -d
		sudo nix-env --delete-generations old
		sudo nix-collect-garbage
		sudo nix-collect-garbage -d
	}
	nixops() {
		$HOME/code/colemickens/nixops/result/bin/nixops "$@"
	}
fi


############################################################################################################################
# Arch
############################################################################################################################

if [[ "$PLATFORM_DISTRO" == "arch" ]]; then
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
	local date="$(date +"%Y%m%d-%H%M%S")"
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

github_load_keys() {
	curl https://github.com/colemickens.keys > $HOME/.ssh/authorized_keys_backup
	mv $HOME/.ssh/authorized_keys_backup $HOME/.ssh/authorized_keys
}


############################################################################################################################
# Launcher Helpers
############################################################################################################################

mitmproxy() {
	# make sure the secret is here from dropbox, use it in args to mitmproxy
	/usr/bin/env mitmproxy --cadir $HOME/code/colemickens/secrets/mitmproxy "$@"
}


############################################################################################################################
# Generic Helpers
############################################################################################################################

docker_clean() {
	docker rm `docker ps --no-trunc -aq`
	docker images | grep "<none>" | awk '{ print "docker rmi " $3 }' | bash
	docker volume rm $(docker volume ls -qf dangling=true)
}
docker_clean_hard() { docker rmi -f $(docker images -q) }
du_summary() { sudo du -x -h / | sort -hr > $HOME/du_summary.txt }


############################################################################################################################
# SSH Helpers
############################################################################################################################

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
	if [[ "${PLATFORM_OS}" == "mac" ]]; then
		proxy_mac_socks_up
		assh cole@localhost -p 2222 -N -D1080
		proxy_mac_socks_down
	else
		assh cole@localhost -p 2222 -N -D1080
	fi
}

socks_chimera() { autossh -M 0 -p 222 -N -D 1080 -o "ServerAliveInterval 45" -o "ServiceAliveCountMax 2" cole@mickens.io }
sshuttle_chimera() { sshuttle -r cole@mickens.io:222 '0.0.0.0/0' }


############################################################################################################################
# RDP Helpers
############################################################################################################################

rdp_common() {
	set -x
	local rdpserver=$1
	local rdpdomain=$2
	local rdpuser=$3
	local rdppass=$4
	shift 4

	local freerdp_bin=`which xfreerdp`

	local customfreerdp=$HOME/code/FreeRDP/FreeRDP/build/client/X11/xfreerdp
	if [ -f $customfreerdp ]; then
		echo "using custom build"
		freerdp_bin=$customfreerdp
	fi

	local -a rdpopts
	case $(hostname) in
		"pixel")   rdpopts=("/scale:140" "/size:2560x1600") ;;
		"nucleus") rdpopts=("/scale:100" "/size:2560x1380") ;;
		"cmz420")  rdpopts=("/size:1920x1160") ;;
	esac

	$freerdp_bin \
		/cert-ignore \
		/u:$rdpuser \
		/d:$rdpdomain \
		/p:$rdppass \
		$rdpopts \
		+fonts \
		+clipboard \
		+compression \
		+toggle-fullscreen \
		-wallpaper \
		"$@" \
		/v:$rdpserver
}

rdp_cmcrbn() {
	source $HOME/code/colemickens/secrets/work/colemick_credentials
	rdp_common cmcrbn.redmond.corp.microsoft.com $COLEMICK_DOMAIN $COLEMICK_USERNAME $COLEMICK_PASSWORD
}

rdp_cmcrbn_remote() {
	source $HOME/code/colemickens/secrets/work/colemick_credentials
	rdp_common cmcrbn.redmond.corp.microsoft.com $COLEMICK_DOMAIN $COLEMICK_USERNAME $COLEMICK_PASSWORD /g:redmondts.microsoft.com /gd:$COLEMICK_DOMAIN /gu:$COLEMICK_USERNAME /gp:$COLEMICK_PASSWORD 
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


############################################################################################################################
# Kubernetes Helpers
############################################################################################################################

export KUBERNETES_PROVIDER=azure
export KUBE_RELEASE_RUN_TESTS=n
export kubectl_real="$(command which kubectl)"

kubectl_proxy() {
	# use port 9999 since we punch it for cloud vms
	echo "using kubectl: ${kubectl_real}"
	echo "--"
	(set -x; command "${kubectl_real}" proxy --address=0.0.0.0 --accept-hosts='.+' --port 9999)
}

kubectl_() {
	(set -x; command "${kubectl_real}" "${@}" --all-namespaces)
}

kubectl() {
	if [[ -z "${KUBENS:-}" ]]; then
		KUBECTL_NAMESPACE="default"
	fi
	(set -x; command "${kubectl_real}" "${@}" --namespace="${KUBENS}")
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
	REPO="$1"
	IMPORTPATH="$2"
	export GOPATH="${HOME}/code/colemickens/${REPO}_gopath"
	export PATH="${PATH}:${GOPATH}/bin"
	export GO15VENDOREXPERIMENT=1

	cd "${GOPATH}/src/${IMPORTPATH}"
}

cd_autorest() { gopath autorest github.com/Azure/go-autorest }
cd_azkube() { gopath azkube github.com/colemickens/azkube }
cd_azuresdk() { gopath azuresdk github.com/Azure/azure-sdk-for-go }
cd_kubernetes() { gopath kubernetes k8s.io/kubernetes }
cd_asciinema() { gopath asciinema github.com/asciinema/asciinema }

# these are things that vim-go needs, or we otherwise use (glide)
go_update_utils() {
	export GOPATH=$HOME/code/gopkgs

	go get -u github.com/tools/godep

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


############################################################################################################################
# Azure Helpers
############################################################################################################################

export PATH=$PATH:$HOME/code/colemickens/azure-toolkit/helpers

azure_env_reset() {
	declare -a azureenvvars
	azureenvvars=($(env | awk -F "=" '{print $1}' | grep "^AZURE_.*"))
	for e in "${azureenvvars[@]}" ; do
		unset "${e}"
	done
}

azure_env_personal() {
	azure_env_reset
	export AZURE_TENANT_ID="13de0a15-b5db-44b9-b682-b4ba82afbd29"
	export AZURE_SUBSCRIPTION_ID="aff271ee-e9be-4441-b9bb-42f5af4cbaeb"
	export AZURE_CLIENT_ID="20f97fda-60b5-4557-9100-947b9db06ec0"
	export AZURE_CLIENT_SECRET="$(cat $HOME/code/colemickens/secrets/azure/azkubeci__client_secret)"
	export AZURE_AUTH_METHOD="client_secret"
	azure account set "${AZURE_SUBSCRIPTION_ID}"
}

azure_env_work_cs() {
	azure_env_reset
	export AZURE_TENANT_ID="72f988bf-86f1-41af-91ab-2d7cd011db47"
	export AZURE_SUBSCRIPTION_ID="27b750cd-ed43-42fd-9044-8d75e124ae55"
	export AZURE_CLIENT_ID="dad4f1ea-8934-4532-a42c-1de2d62d73b2"
	export AZURE_CLIENT_SECRET="$(cat $HOME/code/colemickens/secrets/azure/colemick-azkubeci__client_secret)"
	export AZURE_AUTH_METHOD="client_secret"
	export AZURE_RESOURCE_GROUP="kube-deploy-sandbox"
	azure account set "${AZURE_SUBSCRIPTION_ID}"
}

azure_env_work_nix() {
	azure_env_reset
	export AZURE_TENANT_ID="72f988bf-86f1-41af-91ab-2d7cd011db47"
	export AZURE_SUBSCRIPTION_ID="27b750cd-ed43-42fd-9044-8d75e124ae55"
	export AZURE_CLIENT_ID="d829416c-7142-4de5-a5ad-bae9719f7b7d"
	export AZURE_SERVICE_PRINCIPAL="${AZURE_CLIENT_ID}"
	export AZURE_CLIENT_SECRET="$(cat $HOME/code/colemickens/secrets/azure/colemick-nixops-client__client_secret)"
	export AZURE_PASSWORD="${AZURE_CLIENT_SECRET}"
	export AZURE_AUTHORITY_URL="https://login.microsoftonline.com/${AZURE_TENANT_ID}"
	azure account set "${AZURE_SUBSCRIPTION_ID}"
}

azure_cleanup() {
	$HOME/code/colemickens/azure-helpers/azure_cleanup.sh "$@"
}
