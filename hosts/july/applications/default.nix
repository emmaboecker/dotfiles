{...}: {
  imports = [
    ./bots
    ./databases
    ./monitoring
    ./matrix.nix
    ./reverse-proxy.nix
    ./immich

    ./authentik.nix

    ./nextcloud.nix
    ./railboard-api.nix
    ./rmbg-server.nix

    ./static.nix
    ./emmalink.nix
    ./pfica-stats.nix

    ./minecraft
    ./fivem.nix
    ./teamspeak.nix

    ./home-assistant.nix

    ./bak-kk
    # ./mail.nix
  ];
}
