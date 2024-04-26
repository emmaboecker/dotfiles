{ ... }: {
  virtualisation.oci-containers.containers.lsa-minecraft = {
    image = "itzg/minecraft-server";

    environment = {
      EULA="TRUE";
      TYPE="FABRIC";
      SERVER_PORT = "25521";
      RCON_PORT = "25721";
      MOTD = "#moderndenken";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="14";
      SIMULATION_DISTANCE="5";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="5G";
      ALLOW_FLIGHT="TRUE";
      MODRINTH_PROJECTS="c2me-fabric,fabric-api,ferrite-core,krypton,lithium,modernfix,servercore,starlight,threadtweak,vmp-fabric,yosbr";
    };

    volumes = [
      "/var/lib/minecraft-lj-lsa:/data/"
    ];

    extraOptions = ["--network=host"];
  };
}