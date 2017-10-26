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
		"pixel")   rdpopts=("/scale:180" "/size:2560x1600") ;;
		"nucleus") rdpopts=("/scale:160" "/size:2560x1380") ;;
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

rdp_sly() {
	USER="cole.mickens@gmail.com"
	SLY="10.0.0.8"
	stty -echo
	printf "RDP Password for '${USER}': "
	read PASSWORD
	rdp_common "${SLY}" "" "cole.mickens@gmail.com" "${PASSWORD}"
}
