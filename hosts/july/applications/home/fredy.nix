{ ... }: {
  systemd.tmpfiles.rules = [
    "d /var/lib/fredy 0700 root root"
    "d /var/lib/fredy/conf 0700 root root"
    "d /var/lib/fredy/db 0700 root root"
  ];

  virtualisation.oci-containers.containers.fredy = {
    image = "ghcr.io/orangecoding/fredy:master";
    pull = "newer";

    environment = {
    };

    volumes = [
      "/var/lib/fredy/conf:/conf"
      "/var/lib/fredy/db:/db"
    ];

    extraOptions = ["--network=host"];
  };

  services.nginx.virtualHosts."fredy.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:9998";
    };
  };
}