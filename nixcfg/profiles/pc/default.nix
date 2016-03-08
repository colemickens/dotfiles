{ config, lib, pkgs, ... }:

{
  imports = [
    ../../users/cole
  ];

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
        addresses = true;
        hinfo = true;
      };
    };
    locate.enable = true;
    mopidy = {
      enable = true;
      configuration = "";
      extensionPackages = [ pkgs.mopidy-gmusic pkgs.mopidy-spotify ];
    };
    openssh.enable = true;
    upower.enable = true;
    xserver = {
      autorun = true;
      desktopManager.gnome3 = {
        enable = true;
        sessionPath = [ pkgs.arc-gtk-theme ];
      };
      displayManager.gdm.enable = true;
      #windowManager.i3.enable = true;
      #displayManager.sddm.enable = true;
      videoDrivers = [ "intel" ];
      enable = true;
      layout = "us";
      libinput = {
        enable = true;
        accelProfile = "adaptive";
        clickMethod = "clickfinger";
        disableWhileTyping = true;
        middleEmulation = false;
        naturalScrolling = true;
        scrollMethod = "twofinger";
        tapping = false;
        tappingDragLock = false;
      };
      useGlamor = true;
    };
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0402|0403|0406|0407|0410", TAG+="uaccess"
    '';
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      fantasque-sans-mono
      corefonts
      powerline-fonts
      inconsolata
      terminus_font
      ubuntu_font_family
      unifont
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      enableAdobeFlash = true;
    };
    chromium = {
      enablePepperFlash = true;
      enableWideVine = true;
    };
  };

  environment.gnome3.excludePackages = with pkgs.gnome3_18 ; [
    baobab empathy epiphany
    gucharmap totem vino yelp
    gnome-calculator gnome-contacts gnome-font-viewer
    gnome-system-log gnome-system-monitor
    gnome-user-docs bijiben evolution
    gnome-clocks gnome-music gnome-photos
    nautilus-sendto vinagre gnome-weather gnome-logs
    gnome-maps gnome-characters gnome-calendar accerciser gnome-nettool
    gnome-getting-started-docs gnome-shell-extensions gnome-documents
  ];

  environment.systemPackages = with pkgs ; [
    xorg.glamoregl
    xorg.xprop
    scrot
    xdotool
    redshift
    tpm-tools
    efibootmgr

    gnome3_18.eog
    gnome3_18.file-roller
    gnome3_18.gdm
    gnome3_18.gedit
    gnome3_18.gnome_control_center
    gnome3_18.gnome_desktop
    gnome3_18.gnome-disk-utility parted gptfdisk
    gnome3_18.gnome_shell
    gnome3_18.gnome_session
    gnome3_18.gnome_settings_daemon
    gnome3_18.gnome_terminal

    mopidy
    mopidy-gmusic
    rtorrent

    wayland
    weston
    sway
    imagemagick # remove this eventually
    orbment
    rofi

    termite

    firefox-wrapper
    chromiumDev
    torbrowser

    #virtmanager
    #virtviewer

    lxappearance
    arc-gtk-theme
    numix-icon-theme
    numix-icon-theme-circle
    tango-icon-theme

    pavucontrol
    mpd
    ncmpcpp
    mpv
    vlc

    inkscape
    graphviz
    gimp

    yubikey-personalization
    yubikey-personalization-gui

    freerdpUnstable

    # nonfree
    dropbox
    sublime3

    # need to package
    # pulseaudio-mixer-git
    # cloudflare-dyndns
  ];
}
