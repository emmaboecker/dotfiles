{ pkgs, self, config, ... }: 
{
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
}