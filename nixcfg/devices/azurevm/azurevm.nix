{ pkgs, ... }:

{
  imports = [
    ../../users/cole/default.nix
  ];

  config = {
    boot = {
      kernelPackages = pkgs.linuxPackages_4_5;
    };
    networking = {
      hostName = "azdev";
      firewall.enable = false;
    };
    time.timeZone = "US/Pacific";
  };
}
