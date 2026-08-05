{ ... }: {
  imports = [
    ./reverse-proxy.nix
    ./jellyfin.nix
    ./databases
    ./minecraft
  ];
}