gotty_() {
	set -x
	local -a flags
	if [[ "$1" == "ro" ]]; then
	elif [[ "$1" == "rw" ]]; then
		flags+=("-w")
	else
		echo "must specify ro/rw"
		return -1
	fi
	shift 1
	gotty "${flags[@]}" --address 0.0.0.0 --port "9111" "$@"
}

gotty_shared_tmux() {
	gotty_ rw tmux new-session -A -s shared "$@"
}
