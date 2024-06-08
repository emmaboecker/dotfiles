{ emmalink, pkgs, self, config, ... }: 
{
  users.users.bakkklinks = {
    isSystemUser = true;
    group = "bakkklinks";
    uid = 1034;
  };
  users.groups.bakkklinks = {
    gid = 1035;
  };

  age.secrets.bakkklinks-secrets.file = "${self}/secrets/bak-kk/links-secrets.age";

  systemd.services.bakkklinks = {
    description = "BAK KK Links";
    after = [ "network.target" "postgresql.service" "bak-kk-links-database.service" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PORT = "3006";
    };
    serviceConfig = {
      EnvironmentFile = config.age.secrets.bakkklinks-secrets.path;
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
      User = config.users.users.bakkklinks.uid;
      Group = config.users.groups.bakkklinks.gid;
    };
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "bakkklinks";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
    ensureDatabases = ["bakkklinks"];
  };

  systemd.services.bak-kk-links-database = {
    description = "BAK KK Links Database";
    after = [ "postgresql.service" ];
    wants = [ "postgresql.service" ];
    serviceConfig = {
      User = "postgres";
      Group = "postgres";
      LoadCredential = "DB_PASSWORD_FILE:${config.age.secrets.emmalink-test-password.path}";
    };

    script = ''
      ${config.services.postgresql.package}/bin/psql -c "ALTER USER bakkklinks PASSWORD '$(${pkgs.systemd}/bin/systemd-creds cat DB_PASSWORD_FILE)';"
    '';
  };

  services.nginx.virtualHosts."l.bak.red" = {
    useACMEHost = "bak.red";
    locations."/" = {
      proxyPass = "http://localhost:3006";
    };
  };
}