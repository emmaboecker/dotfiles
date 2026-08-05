{ ... }: {
  users = {
    users.media = {
      isSystemUser = true;
      group = "media";
    };
    groups.media = {};
  };

  services.jellyfin = {
    enable = true;
    user = "media";
    group = "media";
    openFirewall = true;
  };

  services.nginx.virtualHosts."jelly.boecker.dev".locations."/" = {
    proxyPass = "http://127.0.0.1:8096";
    proxyWebsockets = true;
  };
}