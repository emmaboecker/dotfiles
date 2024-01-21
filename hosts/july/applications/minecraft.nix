{ self, config, ... }:
{
  # virtualisation.oci-containers.containers.minecraft = {
  #   image = "itzg/minecraft-server";

  #   environment = {
  #     EULA="TRUE";
  #     TYPE="PAPER";
  #     MOTD = "hallo";
  #     SPAWN_PROTECTION="0";
  #     VIEW_DISTANCE="16";
  #     SIMULATION_DISTANCE="6";
  #     PLUGINS = "
  #     https://cdn.modrinth.com/data/9eGKb6K1/versions/b2fQucaC/voicechat-bukkit-2.4.28.jar
  #     https://hangarcdn.papermc.io/plugins/CyntrixAlgorithm/DeathChest/versions/2.1.1/PAPER/deathchest.jar
  #     https://hangarcdn.papermc.io/plugins/Blue/BlueMap/versions/3.17/PAPER/BlueMap-3.17-paper.jar
  #     https://cdn.modrinth.com/data/fALzjamp/versions/B0xkCkk4/Chunky-1.3.92.jar
  #     https://ci.lucko.me/job/spark/396/artifact/spark-bukkit/build/libs/spark-1.10.55-bukkit.jar
  #     https://cdn.modrinth.com/data/Lu3KuzdV/versions/w3P6ufP1/CoreProtect-22.2.jar
  #     https://cdn.modrinth.com/data/p1ewR5kV/versions/Ypqt7eH1/unifiedmetrics-platform-bukkit-0.3.8.jar
  #     ";
  #     DISABLE_HEALTHCHECK = "true";
  #     MEMORY="5G";
  #     ALLOW_FLIGHT="TRUE";
  #   };

  #   volumes = [
  #     "/var/lib/etog-minecraft:/data/"
  #   ];

  #   extraOptions = ["--network=host"];
  # };

  # uwumarie.reverse-proxy.services."map.boecker.dev" = {
  #   locations."/" = {
  #     proxyPass = "http://localhost:8100";
  #   };
  # };

  age.secrets.etog-modpack = {
    file = "${self}/secrets/etog-modpack-secrets.age";
  };

  virtualisation.oci-containers.containers.minecraft = {
    image = "itzg/minecraft-server";

    environmentFiles = [
      config.age.secrets.etog-modpack.path 
    ];

    environment = {
      EULA="TRUE";
      TYPE="AUTO_CURSEFORGE";
      MOTD = "hi na";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="14";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="8G";
      ALLOW_FLIGHT="TRUE";
      CF_PAGE_URL="https://www.curseforge.com/minecraft/modpacks/all-the-mods-9";
    };

    volumes = [
      "/var/lib/etog-modpack:/data/"
    ];

    extraOptions = ["--network=host"];
  };
}