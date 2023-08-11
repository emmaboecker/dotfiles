{
  modulesPath,
  lib,
  disko,
  nixpkgs,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/profiles/headless.nix"
    disko.nixosModules.default
    ./hosts/july
  ];

  boot.loader.grub.devices = ["/dev/vda"];

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
}
