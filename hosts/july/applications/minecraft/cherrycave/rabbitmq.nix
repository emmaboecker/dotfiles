{ config, ... }: {
  services.rabbitmq = {
    enable = true;

    managementPlugin = {
      enable = true;
    };
  };

  services.nginx.tailscaleAuth = {
    enable = true;
    virtualHosts = [ "rabbitmq.boecker.dev" ];
  };

  services.nginx.virtualHosts."rabbitmq.boecker.dev".locations."/" = {
    proxyPass = "http://127.0.0.1:${toString config.services.rabbitmq.managementPlugin.port}";
    proxyWebsockets = true;
  };
}
