{
  modulesPath,
  lib,
  disko,
  nixpkgs,
  pkgs,
  ...
}:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/profiles/headless.nix"
    ../../common.nix

    ./hardware.nix
    ./networking.nix
    ./user.nix
    ./storage.nix
    ./applications
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  boot.kernel.sysctl."vm.overcommit_memory" = lib.mkForce "1";

  time.timeZone = "Europe/Berlin";

  system.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  nix = {
    settings = {
      trusted-users = [ "@wheel" ];
    };
    registry.nixpkgs.flake = nixpkgs;
    nixPath = [
      "nixpkgs=${nixpkgs}"
    ];
  };

  programs.nix-ld.enable = true;
}
