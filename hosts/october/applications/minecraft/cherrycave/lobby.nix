{ config, pkgs, ... }: {
  virtualisation.oci-containers.containers.cc-lobby = {
    image = "ghcr.io/cherrycave/lobby:latest";
    pull = "always";

    environmentFiles = [
      config.age.secrets.rabbitmq-env.path
    ];

    environment = {
      PORT="25501";
    };

    extraOptions = ["--network=host"];

    volumes = [
      "${config.age.secrets.velocity-forwarding-secret.path}:/forwarding.secret"
      "${pkgs.writeText "navigator.json" ''
      {
        "items": [
          {
            "slot": 12,
            "material": "minecraft:rabbit_spawn_egg",
            "name":"<gradient:#00ff33:#38ffcd>Marathon</gradient>",
            "description":"",
            "action":{
              "actionType":"send-request",
              "server":"marathon"
            }
          },
          {
            "slot": 14,
            "material": "minecraft:crafting_table",
            "name":"<gradient:#7370ff:#2b95ff>Bingo</gradient>",
            "description":"",
            "action":{
              "actionType":"send-request",
              "server":"bingo"
            }
          },
          {
            "slot": 22,
            "material": "minecraft:red_bed",
            "name":"<gradient:#ff4f4f:#ff860d>Bed Wars</gradient>",
            "description":"",
            "action":{
              "actionType":"send-request",
              "server":"bedwars"
            }
          }
        ]
      }
      ''}:/navigator.json"
      
    ];
  };
}