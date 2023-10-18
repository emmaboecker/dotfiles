{
  # config,
  self,
  ...
}: {
  age.secrets.mongo-root.file = "${self}/secrets/mongo-root.age";

  virtualisation.oci-containers.containers.mongodb = {
    image = "docker.io/mongo";

    environmentFiles = [
      # config.age.secrets.mongo-root.path
    ];

    volumes = [
      "/var/lib/mongodb:/data/db"
    ];

    extraOptions = ["--network=host"];
  };
}
