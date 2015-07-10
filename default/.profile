export MAKEFLAGS="-j 8"
export EDITOR=vim

export GOPATH=/home/cole/Code/gopkgs
export GOROOT=/home/cole/Code/golang/go
export PATH=$PATH:/home/cole/Code/golang/go/bin:/home/cole/Code/gopkgs/bin

twerk_proxy() { autossh -M 20001 -N -T -L33890:localhost:33890 cole@mickens.io }

twerk_rdp() {
    source ~/.secrets

    FREERDP=$HOME/Code/colemickens/FreeRDP/build/client/X11/xfreerdp

    $FREERDP \
        /cert-ignore \
        /v:localhost:33890 \
        /size:2560x1650 \
        /u:colemick \
        /p:"$WINRDPPASSWORD" \
        /scale-device:140 \
        /scale-desktop:140 \
        +fonts \
        +compression \
        +toggle-fullscreen \
        -wallpaper
}

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
    FILENAME=screencast-`date +%Y-%m-%d-%H%M%S`.webm;
    FILEPATH=$HOME/tmp/screencasts/$FILENAME
    eval $(slop);
    ffmpeg -f x11grab -s "$W"x"$H" -i :0.0+$X,$Y -f alsa -i pulse $FILEPATH >/dev/null 2>&1;
    echo $FILEPATH;
}

upload_to_s3_screenshots() {
    FILEPATH=$1
    FILENAME=$(basename $FILEPATH)

    source .secrets;
    aws s3 cp --acl=public-read $FILEPATH s3://colemickens-screenshots/ >/dev/null 2>&1;
    echo "https://colemickens-screenshots.s3.amazonaws.com/$FILENAME"
}

clean_docker() { docker rm `docker ps --no-trunc -aq` }

update_system() {
    yaourt -Syua --noconfirm
    yaourt --aur-url https://aur4.archlinux.org -Syua --noconfirm
}

update_dnx() {
	dnvm upgrade -r coreclr -u -a coreclr-latest
	dnvm upgrade -u -a mono-latest
}

backup_code() {
    FILENAME=colemickens-Code-backup-`date +%Y-%m-%d-%H%M%S`.tar.gz
    FILEPATH=$HOME/$FILENAME

    tar -czf $FILENAME ~/Code/colemickens
    echo $FILENAME: `du -hs $FILEPATH`

    source ~/.secrets
    aws s3 cp $FILENAME s3://colemickens-backups/$FILENAME
    echo "https://colemickens-screenshots.s3.amazonaws.com/$FILENAME"
}

fix_pixel2_audio() {
    cd ~/Code/tsowell/linux-samus/common
    ALSA_CONFIG_UCM=ucm/ alsaucm -c bdw-rt5677 set _verb HiFi
    pacmd set-default-sink 1
}

reflector_run() {
    sudo true
    wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/
    reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S`
    sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}
