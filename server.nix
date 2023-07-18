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
    ./hardware.nix
    ./networking.nix
    ./applications
  ];

  boot.loader.grub.devices = ["/dev/vda"];

  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Europe/Berlin";

  nixpkgs.config.allowUnfree = true;

  users.users.emma = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIh+tAKie4OOkzxIwprEcQHiaL4ifkJKcSeN3bytV1rZ stckoverflw@gmail.com"
    ];
  };
  system.stateVersion = "23.11";

  disko.devices = import ./disk-config.nix {
    inherit lib;
  };

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
