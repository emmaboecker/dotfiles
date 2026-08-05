{ config, ... }: {
  services.reposilite = {
    enable = true;

    settings = {
      port = 3213;
    };
  };

  services.nginx.virtualHosts."maven.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.reposilite.settings.port}";
    };
  };
}
