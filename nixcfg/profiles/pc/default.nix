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
    openssh.enable = true;
    upower.enable = true;
    xserver = {
      autorun = true;
      desktopManager.gnome3 = {
        enable = true;
        sessionPath = [ pkgs.arc-gtk-theme ];
      };
      displayManager.gdm.enable = true;
      videoDrivers = [ "intel" ];
      enable = true;
      layout = "us";
      libinput.enable = true;
      useGlamor = true;
    };
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0402|0403|0406|0407|0410", TAG+="uaccess"
    '';
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [ corefonts fira-mono inconsolata terminus_font ubuntu_font_family unifont ];
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
    gnome-system-log
    gnome-user-docs bijiben evolution
    gnome-clocks gnome-music gnome-photos
    nautilus-sendto vinagre gnome-weather gnome-logs
    gnome-maps gnome-characters gnome-calendar accerciser
    gnome-getting-started-docs gnome-shell-extensions gnome-documents
  ];

  environment.systemPackages = with pkgs pkgs.gnome_3_18; [
    efibootmgr
    xdotool xorg.glamoregl xorg.xprop

    cheese eog file-roller gdm gedit gnome_control_center gnome_desktop gnome-disk-utility parted gptfdisk
    gnome_shell gnome_session gnome_settings_daemon gnome_terminal

    lxappearance arc-gtk-theme numix-icon-theme numix-icon-theme-circle tango-icon-theme

    chromiumDev firefox-wrapper torbrowser

    freerdpUnstable
    gimp
    graphviz
    inkscape
    pavucontrol
    redshift
    scrot
    termite
    virtmanager virtviewer
    vlc
    yubikey-personalization
    yubikey-personalization-gui
  ];
}
