export MAKEFLAGS="-j 8"
export EDITOR=vim

export GOPATH=/home/cole/Code/gopkgs
export GOROOT=/home/cole/Code/golang/go
export PATH=$PATH:/home/cole/Code/golang/go/bin:/home/cole/Code/gopkgs/bin

twerk_proxy() { autossh -M 20001 -N -T -L33890:localhost:33890 cole@cole.mickens.io }

twerk_rdp() {
    source ~/.secrets

    FREERDP=~/Code/irichter/FreeRDP/build/client/X11/xfreerdp

    synclient HorizTwoFingerScroll=0
    rm ~/.config/freerdp/known_hosts

    $FREERDP \
        /cert-ignore \
        /v:localhost:33890
        /size:2560x1600 \
        /u:colemick \
        /p:$WINRDPPASSWORD \
        /scale-device:140 \
        /scale-desktop:140 \
        +fonts \
        +compression \
        +toggle-fullscreen \
        -wallpaper
}

clean_docker() { docker rm `docker ps --no-trunc -aq` }

update_system() { yaourt -Syua --noconfirm }

update_dnx() {
	dnvm upgrade -r coreclr -u -a coreclr-latest
	dnvm upgrade -u -a mono-latest
}

hscroll_enable() { synclient HorizTwoFingerScroll=1 }
hscroll_disable() { synclient HorizTwoFingerScroll=0 }

backup_code() {
    tar -cvzf ~/colemickens-Code-backup-`date +%Y-%m-%d-%H%M%S`.tar.gz ~/Code/colemickens
}

fix_pixel2_audio() {
    cd ~/Code/tsowell/linux-samus/common
    ALSA_CONFIG_UCM=ucm/ alsaucm -c bdw-rt5677 set _verb HiFi
    pacmd set-default-sink 1
}

reflector_run() {
    wget -O /tmp/mirrorlist.new https://www.archlinux.org/mirrorlist/all/
    reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /tmp/mirrorlist.new
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup-`date +%Y-%m-%d-%H%M%S`
    sudo cp /tmp/mirrorlist.new /etc/pacman.d/mirrorlist
}
