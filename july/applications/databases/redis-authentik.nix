{
  self,
  config,
  ...
}: {
  age.secrets.authentik-redis.file = "${self}/secrets/authentik-redis-password.age";

  services.redis.servers.authentik = {
    enable = true;
    port = 6379;

    requirePassFile = config.age.secrets.authentik-redis.path;
  };
}
