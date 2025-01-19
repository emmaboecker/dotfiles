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

    ./minecraft
    ./teamspeak.nix

    ./home-assistant.nix
    ./paperless.nix

    ./bak-kk
  ];
}
