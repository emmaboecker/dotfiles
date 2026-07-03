{ config, pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "d /var/lib/cherrycave/pumpkin-test 0755 cherrycave cherrycave"
  ];

  virtualisation.oci-containers.containers.cc-pumpkin-test = {
    image = "ghcr.io/pumpkin-mc/pumpkin:master";
    pull = "always";

    environmentFiles = [
      # config.age.secrets.rabbitmq-env.path
    ];

    environment = {
    };

    extraOptions = ["--network=host"];

    volumes = [
      "/var/lib/cherrycave/pumpkin-test:/pumpkin"
    ];
  };
}