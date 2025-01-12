{
  config,
  self,
  pkgs,
  ...
}: {
  users.users.nextcloud.extraGroups = ["postgres"];

  age.secrets.nextcloud-admin = {
    file = "${self}/secrets/nextcloud-admin.age";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;

    https = true;
    hostName = "cloud.boecker.dev";

    configureRedis = true;
    caching.apcu = false;

    database.createLocally = true;

    settings = {
      trusted_domains = ["cloud.stckoverflw.net"];

      trusted_proxies = ["127.0.0.1"];
    };

    config = {
      dbtype = "mysql";

      adminpassFile = config.age.secrets.nextcloud-admin.path;      
    };
  };

  services.nginx.virtualHosts."cloud.boecker.dev" = {
    serverAliases = ["cloud.stckoverflw.net"];
  };
}
