{ ... }: {
    systemd.tmpfiles.rules = [
    "d /var/lib/cherrycave/bingo 0755 cherrycave cherrycave"
  ];

    virtualisation.oci-containers.containers.cc-bingo = {
    image = "itzg/minecraft-server:java25";
    pull = "newer";

    environment = {
      EULA="TRUE";
      TYPE="PAPER";
      VERSION="26.1.2";
      SERVER_PORT = "25512";
      RCON_PORT = "25766";
      MOTD = "";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="16";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="4G";
      MODRINTH_PROJECTS = ''
        luckperms
      '';
    };

    volumes = [
      "/var/lib/cherrycave/bingo:/data/"
    ];

    extraOptions = ["--network=host"];
  };
}