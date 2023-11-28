{ ... }:
{
  virtualisation.oci-containers.containers.minecraft = {
    image = "itzg/minecraft-server";

    environment = {
      EULA="TRUE";
      TYPE="PAPER";
      MOTD = "hallo";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="16";
      SIMULATION_DISTANCE="6";
      PLUGINS = "
      https://cdn.modrinth.com/data/9eGKb6K1/versions/b2fQucaC/voicechat-bukkit-2.4.28.jar
      https://hangarcdn.papermc.io/plugins/CyntrixAlgorithm/DeathChest/versions/2.1.1/PAPER/deathchest.jar
      https://hangarcdn.papermc.io/plugins/Blue/BlueMap/versions/3.17/PAPER/BlueMap-3.17-paper.jar
      https://cdn.modrinth.com/data/fALzjamp/versions/B0xkCkk4/Chunky-1.3.92.jar
      https://ci.lucko.me/job/spark/396/artifact/spark-bukkit/build/libs/spark-1.10.55-bukkit.jar
      https://cdn.modrinth.com/data/Lu3KuzdV/versions/w3P6ufP1/CoreProtect-22.2.jar
      ";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="5G";
      ALLOW_FLIGHT="TRUE";
    };

    volumes = [
      "/var/lib/etog-minecraft:/data/"
    ];

    extraOptions = ["--network=host"];
  };

  uwumarie.reverse-proxy.services."map.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:8100";
    };
  };
}