{ ... }:
{
  imports = [
    ./networking.nix
    ./user.nix
    ./hardware.nix
    ../../home/harper.nix
  ];
}