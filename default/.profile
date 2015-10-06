export MAKEFLAGS="-j 8"
export EDITOR=vim

# home network router NAT rules
# 10.0.0.2 is chimera's static IP
# 10.0.0.3 is nucleus's static IP
# --------------------------------------------
#    80:80    TCP/UDP 10.0.0.2 (http-chimera)
#   222:222   TCP/UDP 10.0.0.2 (ssh-chimera)
#   223:223   TCP/UDP 10.0.0.3 (ssh-nucleus)
# 60000:60999 TCP/UDP 10.0.0.2 (mosh-chimera)
# 61000:61999 TCP/UDP 10.0.0.3 (mosh-nucleus)

pathoverride() {
    if [ -d "/home/cole/Code/pathoverride" ]; then
        export PATH=/home/cole/Code/pathoverride/:$PATH
    else
        echo "pathoverride dir doesn't exist"
        return -1
    fi
}

if [ -d "$HOME/Code/golang/go" ]; then
    export GOROOT=$HOME/Code/golang/go
else
    export GOROOT=/usr/lib/go
fi

export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/Code/gopkgs
export PATH=$PATH:$GOPATH/bin

ssh_chimera_remote()  { ssh  cole@mickens.io -p 222  }
ssh_chimera_local()   { ssh  cole@10.0.0.2   -p 222  }
ssh_nucleus_remote()  { ssh  cole@mickens.io -p 223 }
ssh_nucleus_local()   { ssh  cole@10.0.0.3   -p 223  }
mosh_chimera_remote() { mosh cole@mickens.io --ssh="ssh -p 222" }
mosh_chimera_local()  { mosh cole@10.0.0.2   --ssh="ssh -p 222" }
mosh_nucleus_remote() { mosh cole@mickens.io --ssh="ssh -p 223" -p 61000:61999 }
mosh_nucleus_local()  { mosh cole@10.0.0.3   --ssh="ssh -p 223" -p 61000:61999 }

proxy_nucleus_rdp() {
    autossh -M 20002 -N -T -L33890:10.0.0.3:3389 cole@mickens.io -p 222
}
rdp_nucleus() {
    source ~/Dropbox/.secrets
    # TODO(colemickens): this is unreliable after first windows boot
    #     Filed as an issue against FreeRDP:
    #     https://github.com/FreeRDP/FreeRDP/issues/2876
    rdp_common localhost:33890 $NUCLEUS_USERNAME $NUCLEUS_PASSWORD
    if [ $? -ne 0 ]; then
        echo trying with rdesktop
        timeout 10 rdesktop -u $NUCLEUS_USERNAME -p $NUCLEUS_PASSWORD localhost:33890
        rdp_common localhost:33890 $NUCLEUS_USERNAME $NUCLEUS_PASSWORD
    fi
}

rdp_common() {
    local rdpserver=$1
    local rdpuser=$2
    local rdppass=$3
    local customfreerdp=$HOME/Code/colemickens/FreeRDP/build/client/X11/xfreerdp

    local freerdp_bin=`which xfreerdp`
    if [ -f $customfreerdp ]; then
        freerdp_bin=$customfreerdp
    fi

    local -A rdpopts
    rdpopts[nucleus]="/size:2560x1405"
    rdpopts[pixel]="/size:2560x1650 /scale-device:140 /scale-desktop:140"
    rdpopts[colemick-carbon]="/size:1910x1100"

    local rdpoptions=$rdpopts[$(hostname)]

    $freerdp_bin \
        /cert-ignore \
        /v:$rdpserver \
        /u:$rdpuser \
        /p:$rdppass \
        $rdpoptions \
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
    wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/ \
    && reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new \
    && sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S` \
    && sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}

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

if [ -f "$HOME/.profile-microsoft" ]; then
    source $HOME/.profile-microsoft
fi
