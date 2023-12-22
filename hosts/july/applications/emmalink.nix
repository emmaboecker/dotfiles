{ pkgs, self, config, ... }: 
{
  users.users.emmalink = {
    isSystemUser = true;
    group = "emmalink";
    uid = 1025;
  };
  users.groups.emmalink = {
    gid = 1026;
  };

  age.secrets.emmalink-secrets.file = "${self}/secrets/emmalink-secrets.age";

  virtualisation.oci-containers.containers.emmalink = {
      image = "ghcr.io/emmaboecker/emmalink/web:latest";

      environmentFiles = [
        config.age.secrets.emmalink-secrets.path
      ];

      environment = {
        PORT = "3005";
      };

      volumes = [
        "/run/postgresql:/run/postgresql:ro"
      ];

      extraOptions = [
        "--network=host"
      ];

      user = "${toString config.users.users.emmalink.uid}:${toString config.users.groups.emmalink.gid}";
    };

  services.postgresql = {
    ensureUsers = [
      {
        name = "emmalink";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
    ensureDatabases = ["emmalink"];
  };

  age.secrets.emmalink-test-password.file = "${self}/secrets/emmalink-test-password.age";

  systemd.services.emmalink-database = {
    description = "Emmalink Database";
    after = [ "postgresql.service" ];
    wants = [ "postgresql.service" ];
    serviceConfig = {
      User = "postgres";
      Group = "postgres";
      LoadCredential = "DB_PASSWORD_FILE:${config.age.secrets.emmalink-test-password.path}";
    };

    script = ''
      ${config.services.postgresql.package}/bin/psql -c "ALTER USER emmalink PASSWORD '$(${pkgs.systemd}/bin/systemd-creds cat DB_PASSWORD_FILE)';"
    '';
  };

  uwumarie.reverse-proxy.services."l.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:3005";
      proxyWebsockets = true;
    };
  };
}