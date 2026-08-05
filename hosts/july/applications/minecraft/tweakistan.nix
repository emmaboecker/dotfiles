{ ... }: {
  systemd.tmpfiles.rules = [
    "d /var/lib/tweakistan 0755 valle users"
  ];

  users.users.valle = {
    isNormalUser = true;
    linger = true;
    extraGroups = [
      
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQMSHWPTtZ7CM2yv0Feo3mtI8xGUPLJywKE1NRScvLQ"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFu0KcwKbvHogI9A1s3/hbvErKAZVsft7zlQVezljfB"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    25566
  ];

  networking.firewall.allowedUDPPorts = [
    25566
    24455
  ];

  virtualisation.oci-containers.containers.tweakistan = {
    image = "itzg/minecraft-server:java25";
    pull = "newer";

    environment = {
      EULA="TRUE";
      TYPE="FABRIC";
      VERSION="26.1.2";
      SERVER_PORT = "25566";
      RCON_PORT = "25766";
      MOTD = "";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="22";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      ICON="https://static.boecker.dev/chicken_jockey.jpeg";
      MEMORY="6G";
      MODS= '' 
        https://files.boecker.dev/shr/plugins/unifiedmetrics-platform-fabric-0.3.10-SNAPSHOT.jar
      '';
      MODRINTH_PROJECTS = ''
        fabric-api
        fabric-language-kotlin
        simple-voice-chat
        spark
        chunky
        c2me-fabric
        scalablelux
        lithium
        no-chat-reports
        enhanced-groups
        journeymap
        bluemap
        no-enderman-grief
      '';
      MODRINTH_ALLOWED_VERSION_TYPE="alpha";
      UID="0";
      GID="0";
    };

    user = "0:0";
    podman.user = "valle";

    volumes = [
      "/var/lib/tweakistan:/data/"
    ];

    extraOptions = ["--network=host"];
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "tweakistan";
      static_configs = [
        {
          targets = ["localhost:9101"];
          labels = {
            "server"="tweakistan.boecker.dev";
          };
        }
      ];
    }
  ];

  services.nginx.virtualHosts."tweakistan.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:8101";
      proxyWebsockets = true; 
    };
  };
}