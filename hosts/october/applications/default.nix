{ ... }: {
  imports = [
    ./reverse-proxy.nix
    ./jellyfin.nix
    ./restic-server.nix
    ./databases
    ./minecraft
  ];
}