{ ... }: {
  services.nginx.virtualHosts."static.boecker.dev" = {
    locations."/" = {
      root = "/var/lib/static";
    };
  };
}