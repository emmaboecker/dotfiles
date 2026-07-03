{ self, ... }: {
  imports = [
     ./luckperms.nix
     ./rabbitmq.nix
     ./proxy.nix
     ./lobby.nix
     ./marathon.nix
     ./bingo.nix
   ];

  users = {
    users.cherrycave = {
      isSystemUser = true;
      linger = true;
      group = "cherrycave";
    };
    groups.cherrycave = { };
    users.emma.extraGroups = [ "cherrycave" ];
  };

  age.secrets.velocity-forwarding-secret.file = "${self}/secrets/cherrycave/velocity-forwarding-secret.age";

  age.secrets.rabbitmq-env.file = "${self}/secrets/cherrycave/rabbitmq-env.age";
}