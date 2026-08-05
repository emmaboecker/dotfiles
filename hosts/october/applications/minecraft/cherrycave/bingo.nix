{ bingo-rp-gen, pkgs, ... }: {
    systemd.tmpfiles.rules = [
    "d /var/lib/cherrycave/bingo 0775 cherrycave cherrycave"
    "d /var/lib/cherrycave/bingo/rp-gen 0775 cherrycave cherrycave"
  ];

  virtualisation.oci-containers.containers.cc-bingo = {
    image = "itzg/minecraft-server:java25";
    pull = "newer";

    environment = {
      EULA="TRUE";
      TYPE="PAPER";
      VERSION="26.2";
      SERVER_PORT = "25512";
      RCON_PORT = "25766";
      MOTD = "";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="16";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="8G";
      MODRINTH_PROJECTS = ''
        luckperms
      '';
      RP_GEN_URL="https://bingo.oct.boecker.dev";
    };

    volumes = [
      "/var/lib/cherrycave/bingo:/data/"
    ];

    extraOptions = ["--network=host"];
  };

  systemd.services.bingo-rp-gen = {
    description = "Bingo RP Gen";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Environment = "\"LISTEN_PORT=25409\"";
      ExecStart = "${bingo-rp-gen.packages.${pkgs.system}.default}/bin/bingo_texture_gen";
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
      WorkingDirectory="/var/lib/cherrycave/bingo/rp-gen";
    };
  };

  services.nginx.virtualHosts."bingo.oct.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:25409";
    };
  };
}