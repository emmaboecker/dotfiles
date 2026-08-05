{ bingo-rp-gen, pkgs, ... }: {
    systemd.tmpfiles.rules = [
    "d /var/lib/cherrycave/paper-test 0775 cherrycave cherrycave"
  ];

  virtualisation.oci-containers.containers.cc-paper-test = {
    image = "itzg/minecraft-server:java25";
    pull = "newer";

    environment = {
      EULA="TRUE";
      TYPE="PAPER";
      VERSION="26.2";
      SERVER_PORT = "25531";
      RCON_PORT = "25766";
      MOTD = "";
      SPAWN_PROTECTION="0";
      VIEW_DISTANCE="16";
      SIMULATION_DISTANCE="6";
      DISABLE_HEALTHCHECK = "true";
      MEMORY="8G";
      MODRINTH_PROJECTS = ''
        luckperms
      '';
    };

    volumes = [
      "/var/lib/cherrycave/paper-test:/data/"
    ];

    extraOptions = ["--network=host"];
  };
}