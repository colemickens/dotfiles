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
    #kernelPackages = pkgs.linuxPackages_4_4;
    #kernelPackages = pkgs.linuxPackages_samus_4_4;
    kernelPackages = pkgs.linuxPackages_chromiumos_3_14;
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
    hostName = "pixel";
    networkmanager.enable = true;
    nat = {
      enable = true;
      externalInterface = "wlp1s0";
    };
  };

  services.openssh.ports = [ 224 ];
  services.tlp.enable = true;

  time.timeZone = "US/Pacific";

  # safe to enable on Chromebook Pixel 2015?
  nixpkgs.config.pulseaudio = true;
  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    pulseaudio.enable = true;
  };
  powerManagement.enable = true;

  environment.systemPackages = [ pkgs.mxt_app ];
}
