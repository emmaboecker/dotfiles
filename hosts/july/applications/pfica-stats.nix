{ pfica-stats, pkgs, self, config, ... }: 
{
  users.users.pfica-stats = {
    isSystemUser = true;
    group = "pfica-stats";
    uid = 1127;
  };
  users.groups.pfica-stats = {
    gid = 1128;
  };

  age.secrets.pfica-stats-secrets.file = "${self}/secrets/pfica-stats-secrets.age";

  systemd.services.pfica-stats = {
    enable = false;
    description = "PfiCa Stats";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      LISTEN_URL = "0.0.0.0:3425";
      MONGO_DB = "pfica-stats";
      CORS_ORIGINS = "https://pfingst.camp/tickets";
    };
    serviceConfig = {
      EnvironmentFile = config.age.secrets.pfica-stats-secrets.path;
      ExecStart = "${pfica-stats.packages.${pkgs.system}.default}/bin/pfica-stats";
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
      User = config.users.users.pfica-stats.uid;
      Group = config.users.groups.pfica-stats.gid;
    };
  };

  services.nginx.virtualHosts."pfica-stats.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:3425";
      extraConfig = "
        add_header 'Access-Control-Allow-Origin' 'https://pfingst.camp';
        add_header 'Access-Control-Allow-Headers' '*';
        add_header 'Access-Control-Allow-Methods' 'POST, OPTIONS';
      ";
    };
  };
}