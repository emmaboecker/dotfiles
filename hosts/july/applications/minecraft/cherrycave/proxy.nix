{ config, pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "d /var/lib/cherrycave/proxy 0755 cherrycave cherrycave"
    "d /var/lib/cherrycave/proxy/server 0755 cherrycave cherrycave"
    "d /var/lib/cherrycave/proxy/plugins 0755 cherrycave cherrycave"
    "d /var/lib/cherrycave/proxy/config 0755 cherrycave cherrycave"
  ];

  networking.firewall.allowedTCPPorts = [
    25565
  ];

  networking.firewall.allowedUDPPorts = [
    25565
  ];

  virtualisation.oci-containers.containers.cc-proxy = {
    image = "itzg/mc-proxy:java25";
    pull = "newer";

    environmentFiles = [
      config.age.secrets.rabbitmq-env.path
    ];

    environment = {
      EULA="TRUE";
      TYPE="VELOCITY";
      MINECRAFT_VERSION="26.1.2";
      ENABLE_RCON="true";
      # PLUGINS=''
      #   https://github.com/Cubxity/UnifiedMetrics/releases/download/v0.3.x-SNAPSHOT/unifiedmetrics-platform-bukkit-0.3.10-SNAPSHOT.jar
      #   https://static.boecker.dev/CoreProtect-23.0.jar
      #   https://static.boecker.dev/kommunismus-1.0.0.jar
      # '';  
      MODRINTH_PROJECTS = ''
        luckperms
        viaversion
      '';
    };

    extraOptions = ["--network=host"];

    volumes = [
      "/var/lib/cherrycave/proxy/server:/server/"
      "${config.age.secrets.velocity-forwarding-secret.path}:/server/forwarding.secret"
      "${pkgs.writeText "servers.json" ''
        {
          "servers":[
            {
              "name": "lobby",
              "hostname":"[::1]",
              "port":25501
            },
            {
              "name": "marathon",
              "hostname":"[::1]",
              "port":25511
            },
            {
              "name": "bingo",
              "hostname":"[::1]",
              "port":25512
            },
            {
              "name": "bedwars",
              "hostname":"100.80.45.22",
              "port":25566
            }
          ]
        }
        ''}:/server/plugins/velocity-core/servers.json"
        "${pkgs.writeText "ping.json" ''
        {
          "protocolVersion": 775,
          "protocolName": "Cherry Cave",
          "samplePlayers": [
          ],
          "motd": "              <bold><gradient:#ff0080:light_purple>Cherry Cave</gradient></bold><reset> <gray>♦ <white>[26.1.2]<newline>           <gray>Made with <light_purple>❤</light_purple> in <gradient:#8052fe:#e1416a>Kotlin</gradient> and <#D34516>Rust",
          "favicon": "data:image/png;base64,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"
        }
        ''}:/server/plugins/velocity-core/ping.json"
    ];
  };
}