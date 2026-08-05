{ self, config, ... }: {
  services.restic.server = {
    enable = true;
  
    listenAddress = "[::]:8089";

    extraFlags = [
      "--no-auth"
    ];
  };

  services.nginx.virtualHosts."restic.oct.boecker.dev".locations."/" = {
    proxyPass = "http://127.0.0.1:8089";
  };

  services.nginx.tailscaleAuth = {
    enable = true;
    virtualHosts = [ "restic.oct.boecker.dev" ];
  };
}