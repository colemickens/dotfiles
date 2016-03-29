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

  # security.pki.certificateFiles = [ "/home/cole/code/colemickens/secrets/mitmproxy/mitmproxy-ca-cert.cer" ];

  users.extraUsers.cole = {
      isNormalUser = true;
      hashedPassword = "$6$QkpMbkmyIIj$CY3Q81hMUd.1wOlEfJcESJ2JYWZM0yVGl5Dwf1vgVnyXm2aSb60Sl.H3LGiz/fl/305DZzFSI0SNEeAdZZvol.";
      shell = "/run/current-system/sw/bin/zsh";
      home = "/home/cole";
      extraGroups = [ "wheel" "networkmanager" "kvm" "libvirtd" "docker" ];
      uid = 1000;
  };

  environment.systemPackages = with pkgs ; [
    (lib.overrideDerivation pkgs.tmux (oldAttrs: {
      rev = "5658b628b9bf1c1e0bd5856736332ce8b9c51517";
      name = "tmux-git";
      src = fetchFromGitHub {
        rev = "5658b628b9bf1c1e0bd5856736332ce8b9c51517";
        owner = "tmux";
        repo = "tmux";
        sha256 = "04gq5avvskx3320clqriinawg6m9n6ch34yhlvjxgd63zxk7h0fg";
      };
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ automake autoconf ];
      preConfigure = "sh autogen.sh";
      postInstall = "mkdir -p $out/etc/bash_completion.d";
    }))

    azure-cli awscli google-cloud-sdk

    neovim

    openssh autossh mosh sshuttle
    lsof fzf nmap_graphical

    asciinema
    goPackages.azure-vhd-tools-for-go.bin
    bind
    cryptsetup
    curl
    file
    ffmpeg
    fswatch
    gettext
    gist
    gnupg
    gitAndTools.hub
    gotty
    httpie
    imgurbash
    iotop
    ipfs
    htop
    jq
    keybase
    npm2nix
    less
    lsof
    openssl
    pciutils
    peco
    psmisc
    pythonPackages.mitmproxy
    slop
    stow
    sqlite
    tree
    valgrind
    weechat
    wget
    which
    usbutils

    cmake gnumake
    cvs git tig darcs mercurial subversion
    p7zip unrar parallel unzip xz zip

    cargo rustc racerRust
    gcc go nodejs
    python python3
    ruby

    dropbox-cli
  ];
}
