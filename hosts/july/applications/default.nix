{...}: {
  imports = [
    ./bots
    ./databases
    ./monitoring
    ./matrix.nix
    ./reverse-proxy.nix
    ./immich
    ./media

    ./kanidm.nix
    ./vaultwarden.nix
    
    ./files
    ./railboard-api.nix
    ./rmbg-server.nix
    ./memos.nix
    
    ./reposilite.nix

    ./streaming

    ./static.nix

    ./minecraft

    ./home
  ];
}
