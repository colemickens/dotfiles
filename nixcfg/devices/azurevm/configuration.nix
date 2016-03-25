{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualization/azure-common.nix"
    ./azurevm.nix
  ];

  nix = {
    maxJobs = 8;
    nixPath = [
      "nixos-config=/etc/nixos/configuration.nix"
      "nixpkgs=/nixpkgs"
    ];
  };
}
