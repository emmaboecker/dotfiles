# Immich configuration file from Marie (https://chaos.social/@marie/)!
{ pkgs, lib, config, ... }:
{
  services.immich = {
    enable = true;
    settings = null;
  };

  users.users.immich.uid = 52089350;
  users.groups.immich.gid = 1020473861;
  users.groups.immich-data = { }; 

  services.nginx.virtualHosts."immich.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:2283";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout       600s;
      '';
    };
  };
}
