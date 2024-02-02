{
  self,
  config,
  railboard-api,
  pkgs,
  ...
}: {
  age.secrets.ris-tokens.file = "${self}/secrets/ris-tokens.age";

  systemd.services.railboard-api = {
    after = ["redis-railboard.service"];
    wants = ["redis-railboard.service"];
  };

  systemd.services.railboard-api = {
    description = "Railboard API";
    wantedBy = [ "multi-user.target" ];
    # environment = {
    # };
    serviceConfig = {
      EnvironmentFile = config.age.secrets.ris-tokens.path;
      Environment = "\"API_URL=0.0.0.0:6969\" \"REDIS_URL=unix:///run/redis-railboard/redis.sock\"";
      ExecStart = "${railboard-api.packages.${pkgs.system}.default}/bin/railboard-api";
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
      SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
      DynamicUser = "yes";
    };
  };

  services.nginx.virtualHosts."api.rail.boecker.dev" = {
    serverAliases = ["api.rail.stckoverflw.net"];

    locations."/" = {
      proxyPass = "http://localhost:6969";

      extraConfig = ''
        add_header 'Access-Control-Allow-Origin' '*';
      '';
    };
  };
}
