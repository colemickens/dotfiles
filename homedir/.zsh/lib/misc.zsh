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

du_summary() { sudo du -x -h / | sort -hr > $HOME/du_summary.txt }


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
