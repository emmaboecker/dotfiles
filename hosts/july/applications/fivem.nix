{ self, config,  ... }:
{
  # security.sudo.extraRules = [
  #   { groups = [ "fivem" ]; commands = [ "systemctl restart podman-fivem.service" ]; }
  # ];
#   environment.systemPackages = [
#   (pkgs.writeScriptBin "restart-fivem"
#     ''
#       ${config.security.sudo.package}/bin/sudo systemctl restart podman-fivem.service $@
#     ''
#    )
# ];

  users.groups.fivem = {
  };

  age.secrets.fivem-secrets = {
    file = "${self}/secrets/fivem-secrets.age";
    owner = "etog";
    group = "fivem";
  };

  virtualisation.oci-containers.containers.fivem = {
    image = "spritsail/fivem";

    autoStart = false;
 
    environmentFiles = [
      config.age.secrets.fivem-secrets.path 
    ];

    environment = {};

    volumes = [
      "/var/lib/gta:/config"
    ];

    extraOptions = [
      "--network=host" 
      "-ti"
    ];
  };

  services.nginx.virtualHosts."fivem.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:40120";
    };
  };
}