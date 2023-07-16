{
  self,
  config,
  ...
}: {
  age.secrets.ris-tokens.file = "${self}/secrets/ris-tokens.age";

  virtualisation.oci-containers.containers.railboard-api = {
    image = "ghcr.io/stckoverflw/railboard-api:9f407d7987aecd3a36d0e083dc21080f231b1f49";

    environmentFiles = [
      config.age.secrets.ris-tokens.path
    ];

    environment = {
      API_URL = "0.0.0.0:8069";
      REDIS_URL = "unix:///run/redis-railboard/redis.sock";
    };

    extraOptions = ["--network=host"];
  };

  systemd.services.podman-railboard-api = {
    after = ["redis-railboard.service"];
    wants = ["redis-railboard.service"];
  };

  uwumarie.reverse-proxy.services."api.rail.boecker.dev" = {
    serverAliases = ["api.rail.stckoverflw.net"];

    locations."/" = {
      proxyPass = "http://localhost:8069";

      extraConfig = ''
          add_header Access-Control-Allow-Origin "*";
        '';
    };
  };
}
