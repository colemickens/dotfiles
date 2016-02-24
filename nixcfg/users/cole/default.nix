{ config, lib, pkgs, ... }:

let
  secrets = import "/secrets";
in
{
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  boot.kernel.sysctl = {
    "fs.inotify.max_user_instances" = 256;
    "fs.inotify.max_user_watches" = 500000;
  };

  virtualisation = {
    docker.enable = true;
    rkt.enable = true;
    libvirtd.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  environment.shellAliases = {
    nvi = "nvim";
    vi = "nvim";
    vim = "nvim";
  };

  programs.zsh = {
    enable = true;
    promptInit = "";
  };

  users.mutableUsers = false;

  security.pki.certificateFiles = [ "/secrets/mitmproxy/mitmproxy-ca-cert.cer" ];

  services.syncAuthKeysFromGitHub = {
    enable = false;
    gitHubUserName = "colemickens";
    userName = "cole";
    wgetOptions = "--no-check-certificate"; # this is embarrassingly horribly stupid, don't do this
  };

  users.extraUsers.cole = {
      isNormalUser = true;
      hashedPassword = secrets.cole.hashedPassword;
      shell = "/run/current-system/sw/bin/zsh";
      home = "/home/cole";
      extraGroups = [ "wheel" "networkmanager" "kvm" "libvirtd" "docker" ];
      uid = 1000;
  };

  environment.systemPackages = with pkgs ; [
    lsof
    asciinema
    awscli
    azure-cli
    google-cloud-sdk
    kubernetes
    ipfs
    iotop
    keybase
    npm2nix
    cryptsetup
    gettext

    openssh
    autossh
    nmap_graphical
    tmux
    byobu
    mosh
    fzf

    neovim
    irssi

    cvs
    git
    darcs
    mercurial
    subversion
    pijul

    gitAndTools.hub
    tig

    cmake
    gnumake

    cargo
    gcc
    go
    nodejs
    python
    python3
    racerRust
    ruby
    rustc
    jq

    valgrind

    bashmount
    bind
    curl
    httpie
    file
    gist
    gotty
    htop
    imgurbash
    pythonPackages.mitmproxy
    pciutils
    psmisc
    ranger
    stow
    tree
    wget
    which
    usbutils

    gnupg
    openssl

    p7zip
    unrar
    unzip
    xz
    zip
  ];
}
