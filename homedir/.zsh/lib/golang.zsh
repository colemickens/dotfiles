export GOPATH=$HOME/code/gopkgs
export PATH=${PATH}:$HOME/code/gopkgs/bin

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
