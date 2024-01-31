{
  pkgs,
  iws-rs,
  self,
  config,
  ...
}:
{
  age.secrets.iws-rs.file = "${self}/secrets/iws-rs.age";

  systemd.services.iws-rs = {
    description = "IWS Discord Bot";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      RUST_LOG = "DEBUG";
    };
    serviceConfig = {
      EnvironmentFile = config.age.secrets.iws-rs.path;
      ExecStart = "${iws-rs.packages.${pkgs.system}.default}/bin/iws-rs";
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

  nix.settings = {
    substituters = [ "https://iws-rs.cachix.org" ];
    trusted-public-keys = [ "iws-rs.cachix.org-1:gSraEErjoEJ7F9wjJtQsFKr/8p5pBrHFb5Lwd3YYykU=" ];
  };

  services.nginx.virtualHosts."iws.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:8080";
    };
  };
}