{...}: {
  imports = [
    ./bots
    ./databases
    ./monitoring
    ./matrix.nix
    ./reverse-proxy.nix

    ./authentik.nix

    ./nextcloud.nix
    ./railboard-api.nix

    ./static.nix
    ./emmalink.nix

    ./minecraft.nix
    ./fivem.nix
    ./teamspeak.nix

    ./home-assistant.nix
  ];
}
