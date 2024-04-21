{ ... }:
{
  

  virtualisation.oci-containers.containers.bak-kk-minecraft = {
    image = "itzg/minecraft-server";

    environment = {
      EULA="TRUE";
      TYPE="FORGE";
      VERSION="1.20.1";
      MOTD = ":3";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="14";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="8G";
      ALLOW_FLIGHT="TRUE";
    };

    volumes = [
      "/var/lib/elias-joost-minecraft:/data/"
    ];

    extraOptions = ["--network=host"];
  };

  
}