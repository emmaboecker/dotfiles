{ ... }: {
  systemd.tmpfiles.rules = [
    "d /var/lib/minecraft-lj-stream 0755 emma users"
  ];

  virtualisation.oci-containers.containers.lj-stream-minecraft = {
    image = "itzg/minecraft-server:java21";

    environment = {
      EULA="TRUE";
      TYPE="FABRIC";
      VERSION="1.21.4";
      SERVER_PORT = "25565";
      RCON_PORT = "25722";
      MOTD = "linksjugend-solid.de";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="16";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="7G";
      ALLOW_FLIGHT="TRUE";
      MODRINTH_MODPACK="adrenaserver";
      DIFFICULTY = "hard";
    };

    volumes = [
      "/var/lib/minecraft-lj-stream:/data/"
    ];

    extraOptions = ["--network=host"];
  };
}