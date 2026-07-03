{ self, config, ... }: {
  age.secrets.luckperms-standalone-env.file = "${self}/secrets/cherrycave/luckperms-standalone-env.age";

  virtualisation.oci-containers.containers.luckperms = {
    image = "ghcr.io/luckperms/rest-api";
    pull = "newer";

    environmentFiles = [
      config.age.secrets.luckperms-standalone-env.path
    ];
    environment = {
      LUCKPERMS_REST_HTTP_PORT = "25401";
    };

    extraOptions = ["--network=host"];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "luckperms"
    ];
    ensureUsers = [
      {
        name = "luckperms";
      }
    ];
  };

  systemd.services.podman-luckperms = {
    wants = [
      "postgresql.target"
      "luckperms-postgresql-setup.service"
    ];
    after = [
      "postgresql.target"
      "luckperms-postgresql-setup.service"
    ];
  };

  systemd.services.luckperms-postgresql-setup = {
    description = "Luckperms PostgreSQL setup";
    after = [ "postgresql.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
      Group = "postgres";
      ExecStart = [
        "${config.services.postgresql.package}/bin/psql -c 'ALTER DATABASE \"luckperms\" OWNER TO \"luckperms\";'"
      ];
    };
  };
}