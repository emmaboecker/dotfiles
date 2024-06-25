{ ... }: {
  virtualisation.oci-containers.containers.rmbg-server = {
    image = "ghcr.io/emmaboecker/rmbg-server:main";

    environment = {
      BIND_URL = "0.0.0.0:4221";
    };

    extraOptions = [
      "--network=host"
    ];
  };

  services.nginx.virtualHosts."rmbg.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:4221";
      proxyWebsockets = true;
    };
  };
}