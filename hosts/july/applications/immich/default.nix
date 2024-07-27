# Immich configuration file from Marie (https://chaos.social/@marie/)!
{ pkgs, lib, config, ... }:
let
  yaml = pkgs.formats.yaml { };
  configFile = toString (yaml.generate "config.yml" (import ./settings.nix));
  makeImmichContainer =
    args : lib.recursiveUpdate {
      image = "ghcr.io/immich-app/immich-server:v1.110.0";
      volumes = [
        "/var/lib/immich:/usr/src/app/upload"
        "/run/postgresql:/run/postgresql"
        "${config.services.redis.servers.immich.unixSocket}:${config.services.redis.servers.immich.unixSocket}"
        "${configFile}:/config.yaml"
      ];
      user = "52089350:52089350";
      extraOptions = [ "--network=host" ];
      environment = {
        DB_URL = "postgresql://immich@/immich?host=/run/postgresql";
        REDIS_SOCKET = config.services.redis.servers.immich.unixSocket;
        IMMICH_CONFIG_FILE = "/config.yaml";
      };
    } args;
in
{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "immich" ];
    ensureUsers = [{
      name = "immich";
      ensureDBOwnership = true;
    }];
    extraPlugins = p: with p; [ pgvecto-rs ];
    settings = {
      shared_preload_libraries = "vectors";
    };
  };

  systemd.services.immich-postgresql-create-vectors = {
    after = [ "postgresql.service" ];
    before = [ "podman-immich.service" ];
    requires = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "postgres";
      Group = "postgres";
      Type = "oneshot";
    };

    path = [ config.services.postgresql.package ];

    script = ''
      set -e
      psql -v ON_ERROR_STOP=1 --dbname=immich <<EOF
        BEGIN;
        CREATE EXTENSION IF NOT EXISTS vectors;
        CREATE EXTENSION IF NOT EXISTS earthdistance CASCADE;
        ALTER DATABASE immich SET search_path TO "$\user", public, vectors;
        ALTER SCHEMA vectors OWNER TO immich;
        ALTER EXTENSION vectors UPDATE;
        COMMIT;
      EOF
    '';
  };

  systemd.services.immich-postgresql-fix-permissions = {
    after = [ "podman-immich.service" "postgresql.service" ];
    requires = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "postgres";
      Group = "postgres";
      Type = "oneshot";
    };

    path = [ config.services.postgresql.package ];

    script = ''
      while true;
      do
      if echo "GRANT SELECT ON TABLE pg_vector_index_stat TO immich;" | psql -v ON_ERROR_STOP=1 --dbname=immich; then
          exit 0
        else
          sleep 0.5
        fi
      done
    '';
  };

  services.redis.servers.immich = {
    enable = true;
    user = "immich";
  };
  virtualisation.oci-containers.containers = {
    immich-server = makeImmichContainer { };
    immich-machine-learning = makeImmichContainer {
      image = "ghcr.io/immich-app/immich-machine-learning:v1.110.0";
      volumes = [
        "/var/cache/immich:/cache"
      ];
      environment.MPLCONFIGDIR = "/tmp";
    };
  };
  users.users.immich = {
    isSystemUser = true;
    createHome = true;
    home = "/var/lib/immich";
    group = "immich";
    extraGroups = [ config.services.redis.servers.immich.user "immich-data" ];
    uid = 52089350;
  };
  users.groups.immich = {
    gid = 1020473861;
  };
  users.groups.immich-data = { };

  services.nginx.virtualHosts."immich.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:3001";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout       600s;
      '';
    };
  };

  systemd.tmpfiles.settings."50-immich" = {
    "/var/cache/immich".d = {
      group = "immich";
      user = "immich";
      mode = "0750";
    };
    "/var/lib/immich".d = {
      group = "immich-data";
      user = "immich";
      mode = "2750";
    };
    "/var/lib/immich".Z = {
      group = "immich-data";
      user = "immich";
      mode = "2750";
    };
  };
}
