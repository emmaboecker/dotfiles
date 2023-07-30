{...}: {
  imports = [
    ./reverse-proxy.nix
    ./databases
    ./discord-bots
    ./monitoring
    ./matrix.nix
    ./nextcloud.nix
    ./railboard-api.nix
    ./authentik.nix
  ];
}
