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
