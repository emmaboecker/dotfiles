{
  modulesPath,
  lib,
  disko,
  nixpkgs,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/profiles/headless.nix"
    disko.nixosModules.default
    ./hosts/july
  ];

  environment.systemPackages = with pkgs; [
    git
    htop
    dig
  ];

  boot.loader.grub.devices = ["/dev/vda"];

  boot.kernel.sysctl."vm.overcommit_memory" = lib.mkForce "1";

  disko.devices = import ./hosts/july/disk-config.nix {
    inherit lib;
  };

  time.timeZone = "Europe/Berlin";

  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["@wheel"];
    };
    registry.nixpkgs.flake = nixpkgs;
    nixPath = [
      "nixpkgs=${nixpkgs}"
    ];
  };

  programs.nix-ld.enable = true;
}
