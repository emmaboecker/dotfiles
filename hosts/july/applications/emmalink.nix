{ emmalink, pkgs, self, config, ... }: 
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

  systemd.services.emmalink = {
    description = "Emmalink";
    after = [ "network.target" "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = "3005";
    };
    serviceConfig = {
      EnvironmentFile = config.age.secrets.emmalink-secrets.path;
      ExecStart = "${pkgs.nodejs_20}/bin/node ${emmalink.packages.${pkgs.system}.default}/standalone/server.js";
      Restart = "on-failure";
      CapabilityBoundingSet = [ "" ];
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      ReadWritePaths = [];
      RemoveIPC = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      # SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
      User = config.users.users.emmalink.uid;
      Group = config.users.groups.emmalink.gid;
    };
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

  services.nginx.virtualHosts."l.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:3005";
    };
  };
}