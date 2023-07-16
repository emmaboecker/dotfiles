{...}: {
  services.redis.servers.railboard = {
    enable = true;
    port = 0;
  };
}
