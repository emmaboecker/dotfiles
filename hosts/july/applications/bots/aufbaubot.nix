{
  pkgs,
  aufbaubot,
  self,
  config,
  ...
}:
{
  users.users.aufbaubot = {
    isSystemUser = true;
    group = "aufbaubot";
  };
  users.groups.aufbaubot = {};

  age.secrets.aufbaubot-deletions = {
    file = "${self}/secrets/aufbaubot-deletions.age";
    owner = "aufbaubot";
    group = "aufbaubot";
  };
  age.secrets.aufbaubot-env.file = "${self}/secrets/aufbaubot-env.age";

  systemd.services.aufbaubot = {
    enable = false;

    description = "Telegram Bot for Liste Aufbau in Linksjugend ['solid]";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      DELETIONS_FILE = config.age.secrets.aufbaubot-deletions.path;
    };
    serviceConfig = {
      EnvironmentFile = config.age.secrets.aufbaubot-env.path;
      ExecStart = "${aufbaubot.packages.${pkgs.system}.default}/bin/aufbaubot";
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
      User = "aufbaubot";
      Group = "aufbaubot";
      # DynamicUser = "yes";
    };
  };
}