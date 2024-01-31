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
    package = pkgs.nextcloud28;

    https = true;
    hostName = "cloud.boecker.dev";

    configureRedis = true;
    caching.apcu = false;

    database.createLocally = true;

    config = {
      dbtype = "mysql";

      adminpassFile = config.age.secrets.nextcloud-admin.path;

      extraTrustedDomains = ["cloud.stckoverflw.net"];

      trustedProxies = ["127.0.0.1"];
    };
  };

  services.nginx.virtualHosts."cloud.boecker.dev" = {
    serverAliases = ["cloud.stckoverflw.net"];
  };
}
