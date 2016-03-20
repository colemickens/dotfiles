{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ../../profiles/pc
  ];

  nix = {
    maxJobs = 4;
    nixPath = [
      "nixos-config=/etc/nixos/configuration.nix"
      "nixpkgs=/nixpkgs"
    ];
  };

  system.stateVersion = "16.03";

  boot = {
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
  };

  swapDevices = [ ];

  networking = {
    hostName = "nucleus";
    nat.enable = true;
    networkmanager.enable = true;
  };

  services.openssh.ports = [ 223 ];

  time.timeZone = "US/Pacific";

  services.xserver.useGlamor = lib.mkForce false;

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    pulseaudio.enable = true;
  };

  nixpkgs.config.pulseaudio = true;
}
