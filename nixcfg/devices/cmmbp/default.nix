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
    kernelModules = [ "i915" "kvm-intel" "tun" "virtio" ];
    kernelPackages = pkgs.linuxPackages_4_5;
    extraModulePackages = [ ];
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  swapDevices = [ ];

  networking = {
    hostName = "cmmbp";
    networkmanager.enable = true;
  };

  services.openssh.ports = [ 224 ];
  services.tlp.enable = true;

  time.timeZone = "US/Pacific";

  nixpkgs.config.pulseaudio = true;
  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    pulseaudio.enable = true;
  };
  powerManagement.enable = true;
}
