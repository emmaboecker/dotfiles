{ self, config, ... }: {
  age.secrets.vaultwarden-secrets.file = "${self}/secrets/vaultwarden-secrets.age";

  services.vaultwarden = {
    enable = true;

    config = {
      ROCKET_PORT = 8222;
      PUSH_ENABLED = true;
      SIGNUPS_ALLOWED = false;
      PUSH_RELAY_URI = "https://api.bitwarden.eu";
      PUSH_IDENTITY_URI = "https://identity.bitwarden.eu";
      DNS_PREFER_IPV6 = true;
    };

    dbBackend = "postgresql";
    configurePostgres = true;
    configureNginx = true;

    environmentFile = config.age.secrets.vaultwarden-secrets.path;

    domain = "vault.boecker.dev";
  };

  age.secrets.vaultwarden-backup-password.file = "${self}/secrets/vaultwarden-backup-password.age";

  services.restic.backups.vaultwarden = {
    initialize = true;

    repository = "rest:https://restic.oct.boecker.dev/vaultwarden";

    passwordFile = config.age.secrets.vaultwarden-backup-password.path;

    backupPrepareCommand = ''
      systemctl stop vaultwarden.service
      ${config.security.sudo.package}/bin/sudo -u postgres ${config.services.postgresql.package}/bin/pg_dump vaultwarden > /tmp/vaultwarden.sql
    '';

    backupCleanupCommand = ''
      systemctl start vaultwarden.service
    '';

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 3"
      "--keep-monthly 6"
    ];

    paths = [
      "/var/lib/bitwarden_rs"
      "/tmp/vaultwarden.sql"
    ];

    timerConfig = {
      OnCalendar = "03:00";
      Persistent = true;
    };
  };
}
