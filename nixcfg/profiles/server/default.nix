{ config, lib, pkgs, ... }:

let
  secrets = import "/home/cole/code/colemickens/secrets";
in {
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
    jenkins = {
      enable = true;
      port = 9999;
    };
    locate = {
      enable = true;
    };
    nginx = {
      enable = true;
      config = lib.readFile ./nginx.conf;
    };
    openssh = {
      enable = true;
    };
    plex = {
      enable = true;
    };
    upower = {
      enable = true;
    };
  };

  networking.firewall = {
    enable = false;
  };

  nixpkgs.config = {
    allowUnfree = true;
    plex.enablePlexPass = true;
  };

  environment.systemPackages = with pkgs ; [
    btrfs-progs
    htop
    weechat
    rtorrent
  ];
}
