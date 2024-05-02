{ ... }: {
  virtualisation.oci-containers.containers.lsa-minecraft = {
    image = "itzg/minecraft-server:java21";

    environment = {
      EULA="TRUE";
      TYPE="FABRIC";
      VERSION="1.20.4";
      SERVER_PORT = "25521";
      RCON_PORT = "25721";
      MOTD = "#moderndenken";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="14";
      SIMULATION_DISTANCE="5";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="5G";
      ALLOW_FLIGHT="TRUE";
      MODRINTH_MODPACK="adrenaserver";
    };

    volumes = [
      "/var/lib/minecraft-lj-lsa:/data/"
    ];

    extraOptions = ["--network=host"];
  };
}