{ config, self, ... }:
{
  age.secrets.iws-token.file = "${self}/secrets/iws-token.age";

  virtualisation.oci-containers.containers.iws = {
    image = "ghcr.io/stckoverflw/iws:d7d94b14e7b5bd6dc21e70b30ca48f822006af7d";


    environmentFiles = [
      config.age.secrets.iws-token.path
    ];

    environment = {
      # DISCORD_TOKEN from agenix
      ENVIRONMENT = "PRODUCTION";
      SENTRY_TOKEN = "";
      # MONGO_URL from agenix
      MONGO_DATABASE = "iws_prod";
      LOG_LEVEL = "INFO";
      BOT_OWNERS = "816989010836717599,225301495661199361,828324410015744040";
      OWNER_GUILD = "1040512216895598693";
      UPDATE_PLUGINS = "false";
      WEB_SERVER_HOST = "0.0.0.0";
      WEB_SERVER_URL = "https://iws.boecker.dev";
      PLUGIN_REPOSITORIES = "https://storage.googleapis.com/mikbot-plugins/";
      DOWNLOAD_PLUGINS = "ktor,verification-system,game-animator";
      GAMES = "";
      DISCORD_CLIENT_ID = "1001444901759758347";
      # DISCORD_CLIENT_SECRET from agenix
      VALIDATE_CHECKSUMS = "false";
    };

    volumes = [
      "/var/lib/iws/plugins:/usr/app/plugins"
    ];

    extraOptions = ["--network=host" ];
  };

  systemd.services.podman-iws = {
    after = [ "network-online.target" "podman-mongodb.service" ];
    wants = [ "network-online.target" "podman-mongodb.service" ];
  };

  uwumarie.reverse-proxy.services."iws.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:8080";
    };
  };
} 