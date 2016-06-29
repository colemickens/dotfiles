{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ../../profiles/server
  ];

  nix = {
    maxJobs = 8;
    nixPath = [
      "nixos-config=/etc/nixos/configuration.nix"
      "nixpkgs=/nixpkgs"
    ];
  };

  system.stateVersion = "16.03";

  boot = {
    cleanTmpDir = true;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" ];
    kernelModules = [ "i915" "kvm-intel" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_4_5;
    loader = {
      gummiboot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
    #"/mnt/data" = {
    #  device = "/dev/sdc";
    #  fsType = "btrfs";
    #  options = [ "recovery" "ro" ];
    #};
  };

  swapDevices = [ ];

  networking = {
    hostName = "chimera";
    nat.enable = true;
    networkmanager.enable = true;
  };

  time.timeZone = "US/Pacific";

  services.openssh.ports = [ 222 ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    pulseaudio.enable = true;
  };
  nixpkgs.config.pulseaudio = true;
}
