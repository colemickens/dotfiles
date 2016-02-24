{ config, lib, pkgs, ... }:

let
  secrets = import "/secrets";
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
    cfdyndns = {
      enable = true;
      email = "cole.mickens@gmail.com";
      apikey = secrets.cfdyndns.apikey;
      records = [ "*.mickens.xxx" "mickens.xxx" "*.mickens.io" "mickens.io" "recessionomics.us" "www.recessionomics.us" "*.mickens.me" "mickens.me" "*.mickens.tv" "mickens.tv" "*.mickens.us" "mickens.us" "cole.mickens.us" ];
    };
    #denonavr = {
    #  enable = true;
    #  denonHostname = "10.0.0.17";
    #  webuiPort = 1717;
    #};
    #gitlab = {
    #  enable = true;
    #  databasePassword = secrets.gitlab.databasePassword;
    #  port = 8787;
    #};
    jenkins = {
      enable = true;
      port = 11444;
      jobBuilder = {
        enable = true;
        nixJobs = [
          {
            job = {
              name = "cmpkgs-master-build";
              project-type = "freestyle";
              display-name = "nixpkgs cmpkgs-master build";
              workspace = "/srv/jenkins/cmpkgs-master-build";
              builders = {
                shell = ''
                  echo "test"
                  set -xe
                  echo "test"
                  nix-build '<nixpkgs/nixos>' -A "config.system.build.toplevel" -I "nixos-config=/nixcfg/devices/pixel/default.nix"
                '';
              };

              triggers = {
                "github-pull-request" = {
                  admin-list = [ "colemickens" ];
                  cron = "* * * * *";
                  build-desc-template = "build description";
                  trigger-phrase = "retest";
                  github-hooks = false;
                  white-list-target-branches = [ "master" ];
                };
              };
            };
          }
        ];
      };
    };
    locate.enable = true;
    nginx = {
      enable = true;
      config = lib.readFile ./nginx.conf;
    };
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    plex = {
      enable = true;
    };
    #samba = {
    #  enable = true;
    #  shares = {
    #    media = {
    #      path = "/mnt/data/Media";
    #      "read only" = "yes";
    #      browseable = "yes";
    #      "guest ok" = "yes";
    #    };
    #  };
    #  extraConfig = ''
    #      guest account = nobody;
    #      map to guest = bad user;
    #  '';
    #};
    upower.enable = true;
  };

  networking.firewall = {
    enable = false; # this obliviates everything below # TODO(colemickens): finish this!
    allowPing = true;
    allowedTCPPorts = [
      80 # nginx (denon, etc)
      443 # ssl nginx (see port 80)
    ];
    allowedUDPPortRanges = [
      { from = 60000; to = 60999; } # torrent + mosh
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    plex.enablePlexPass = true;
  };

  environment.systemPackages = with pkgs ; [
    btrfs-progs
    htop
    irssi
    rtorrent

    # nonfree
    dropbox-cli
  ];
}
