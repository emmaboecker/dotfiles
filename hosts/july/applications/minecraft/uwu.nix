{ ... }: {
  virtualisation.oci-containers.containers.uwu-minecraft = {
    image = "itzg/minecraft-server:java21";

    environment = {
      EULA="TRUE";
      TYPE="FABRIC";
      VERSION="1.21.3";
      SERVER_PORT = "25565";
      RCON_PORT = "25721";
      MOTD = "uwu";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="16";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="5G";
      ALLOW_FLIGHT="TRUE";
      MODRINTH_MODPACK="adrenaline";
      MODRINTH_PROJECTS="simple-voice-chat";
      DIFFICULTY = "hard";
    };

    volumes = [
      "/var/lib/minecraft-uwu:/data/"
    ];

    extraOptions = ["--network=host"];
  };
}