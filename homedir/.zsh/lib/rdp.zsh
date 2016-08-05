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

kubectl_proxy() { (set -x; command kubectl proxy --address=0.0.0.0 --accept-hosts='.+' --port 9090) }

kubectl_registry_tunnel() {(
	set -x;
	REGISTRY_POD_NAME="$(kubectl get pods --namespace=kube-system -o json | jq -r '.items | map(select(contains ({"metadata":{"labels":{"k8s-app":"kube-registry"}}}))) | .[0].metadata.name')"
	command kubectl port-forward --namespace=kube-system ${REGISTRY_POD_NAME} 5000
)}

kubens() { command kubectl config set-context "$(kubectl config current-context)" --namespace="$1" }

kctl() { command kubectl "$@" --all-namespaces }

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
