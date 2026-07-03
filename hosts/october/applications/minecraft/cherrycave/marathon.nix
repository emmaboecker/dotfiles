{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.cc-marathon = {
    image = "ghcr.io/cherrycave/marathon:latest";
    pull = "always";

    environmentFiles = [
      # config.age.secrets.rabbitmq-env.path
    ];

    environment = {
      PORT="25511";
    };

    extraOptions = ["--network=host"];

    volumes = [
      "${config.age.secrets.velocity-forwarding-secret.path}:/forwarding.secret"
    ];
  };
}