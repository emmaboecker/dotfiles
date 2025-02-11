{ ... }: {
  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft-lj-stream 0755 emma users"
  ];

  virtualisation.oci-containers.containers.lj-stream-minecraft = {
    image = "itzg/minecraft-server:java21";

    environment = {
      EULA="TRUE";
      TYPE="PAPER";
      VERSION="1.21.4";
      SERVER_PORT = "25565";
      RCON_PORT = "25722";
      MOTD = "linksjugend-solid.de";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="16";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="7G";
      DIFFICULTY = "hard";
      PLUGINS=''
        https://github.com/TCPShield/RealIP/releases/download/2.8.1/TCPShield-2.8.1.jar
        https://github.com/Cubxity/UnifiedMetrics/releases/download/v0.3.x-SNAPSHOT/unifiedmetrics-platform-bukkit-0.3.10-SNAPSHOT.jar
        https://cloud.boecker.dev/s/CqNjbdqjgnLy5nK/download/CoreProtect-22.4.jar
      '';
      MODRINTH_PROJECTS = "chunky,bluemap,luckperms";
    };

    volumes = [
      "/var/lib/minecraft-lj-stream:/data/"
    ];

    extraOptions = ["--network=host"];
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "minecraft";
      static_configs = [
        {
          targets = ["localhost:9100"];
          labels = {
            "server"="minecraft.linksjugend-solid.de";
          };
        }
      ];
    }
  ];

   services.nginx.tailscaleAuth = {
    enable = true;
    virtualHosts = ["lj-map.boecker.dev"]; 
  };
  services.nginx.virtualHosts."lj-map.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:8100";
      proxyWebsockets = true; 
    };
  };
}