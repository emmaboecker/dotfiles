{...}: {
  imports = [
    ./reverse-proxy.nix
    ./databases
    ./discord-bots
    ./telegram-bots/aufbaubot.nix
    ./monitoring
    ./matrix.nix
    ./nextcloud.nix
    ./railboard-api.nix
    ./authentik.nix
  ];
}
