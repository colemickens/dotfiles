{ config, lib, pkgs, ... }:

let
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

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
    #libvirtd.enable = true;
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

  #security.pki.certificateFiles = [ "/secrets/mitmproxy/mitmproxy-ca-cert.cer" ];

  users.extraUsers.cole = {
      isNormalUser = true;
      hashedPassword = "$6$QkpMbkmyIIj$CY3Q81hMUd.1wOlEfJcESJ2JYWZM0yVGl5Dwf1vgVnyXm2aSb60Sl.H3LGiz/fl/305DZzFSI0SNEeAdZZvol.";
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
    goPackages.azure-vhd-tools-for-go.bin
    google-cloud-sdk
    ipfs
    iotop
    keybase
    npm2nix
    cryptsetup
    gettext
    peco

    openssh
    autossh
    mosh
    sshuttle
    nmap_graphical
    fzf

    (lib.overrideDerivation pkgs.tmux (oldAttrs: {
      rev = "b429a00cce4c150cf8050545f903ecb304691ab9";
      name = "tmux-git";
      src = fetchFromGitHub {
        rev = "b429a00cce4c150cf8050545f903ecb304691ab9";
        owner = "tmux";
        repo = "tmux";
        sha256 = "08nnrgrzrahhyiyam39wxbq9k588x6w6y9k3jrrwzk348ji226i3";
      };
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ automake autoconf ];
      preConfigure = "sh autogen.sh";
      postInstall = "mkdir -p $out/etc/bash_completion.d";
    }))

    neovim

    less
    weechat
    fswatch

    cvs
    git
    darcs
    mercurial
    subversion
    #pijul

    gitAndTools.hub
    tig
    dropbox-cli

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
    slop
    ffmpeg

    sqlite

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
    file
    htop
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
    parallel
    unzip
    xz
    zip
  ];
}
