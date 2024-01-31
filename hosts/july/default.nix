{ ... }:
{
  imports = [
    ./applications
    ./hardware.nix
    ./networking.nix
    ./user.nix

    ./dn42
  ];
}