export MAKEFLAGS="-j 8"
export EDITOR=vim

export GOPATH=/home/cole/Code/gopkgs
export GOROOT=/usr/lib/go
export PATH=$PATH:/home/cole/Code/golang/go/bin:/home/cole/Code/gopkgs/bin

proxy_nucleus_rdp() { autossh -M 20002 -N -T -L33890:10.0.0.3:3389 cole@mickens.io -p 222 }

ssh_chimera_remote()  { ssh  cole@mickens.io -p 222  }
ssh_chimera_local()   { ssh  cole@10.0.0.2   -p 222  }
ssh_nucleus_remote()  { ssh  cole@mickens.io -p 223 }
ssh_nucleus_local()   { ssh  cole@10.0.0.3   -p 223  }
mosh_chimera_remote() { mosh cole@mickens.io --ssh="ssh -p 222" }
mosh_chimera_local()  { mosh cole@10.0.0.2   --ssh="ssh -p 222" }
mosh_nucleus_remote() { mosh cole@mickens.io --ssh="ssh -p 223" }
mosh_nucleus_local()  { mosh cole@10.0.0.3   --ssh="ssh -p 223" }

rdp_nucleus() {
    source ~/Dropbox/.secrets
    rdp_common localhost:33890 $NUCLEUS_USERNAME $NUCLEUS_PASSWORD
}

rdp_azure() {
    source ~/Dropbox/.secrets
    rdp_common azureremote01.cloudapp.net:3389 $AZUREWINRDP_USERNAME $AZUREWINRDP_PASSWORD
}

rdp_common() {
    FREERDP=$HOME/Code/colemickens/FreeRDP/build/client/X11/xfreerdp

    $FREERDP \
        /cert-ignore \
        /v:$1 \
        /size:2560x1650 \
        /u:$2 \
        /p:$3 \
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

clean_docker() { docker rm `docker ps --no-trunc -aq` }

dusummary() { sudo du -h / | sort -hr > $HOME/du.txt }

update_system() {
    yaourt -Syua --noconfirm
}

update_dnx() {
	dnvm upgrade -r coreclr -u -a coreclr-latest
}

backup_code() {
    FILENAME=colemickens-Code-backup-`date +%Y-%m-%d-%H%M%S`.tar.gz
    FILEPATH=$HOME/$FILENAME

    tar -czf $FILENAME ~/Code/colemickens
    echo $FILENAME: `du -hs $FILEPATH`

    source ~/Dropbox/.secrets
    aws s3 cp $FILENAME s3://colemickens-backups/$FILENAME
    echo "https://colemickens-screenshots.s3.amazonaws.com/$FILENAME"
}

reflector_run() {
    sudo true
    wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/
    reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S`
    sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}

if [ `hostname` = "nucleus" ]; then
    reboot_windows() {
        BOOTNEXTNUM=`efibootmgr | grep Windows\ Boot\ Manager | sed -n 's/.*Boot\([0-9a-f]\{4\}\).*/\1/p'`
        echo $BOOTNEXTNUM
        sudo efibootmgr --bootnext $BOOTNEXTNUM
        sudo reboot
    }

    reboot_linux() {
        BOOTNEXTNUM=`efibootmgr | grep Linux\ Boot\ Manager | sed -n 's/.*Boot\([0-9a-f]\{4\}\).*/\1/p'`
        echo $BOOTNEXTNUM
        sudo efibootmgr --bootnext $BOOTNEXTNUM
        sudo reboot
    }
fi
