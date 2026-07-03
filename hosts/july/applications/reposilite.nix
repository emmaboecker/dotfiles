{ config, ... }: {
  services.reposilite = {
    enable = true;

    extraArgs = [
      "--token"
      "lou:WSFddffahtf8CLtsJv9NoV8bEpbdwGkS"
    ];

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
