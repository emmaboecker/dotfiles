{ ... }: {

  services.bind = {
    enable = true;

    listenOnIpv6 = [
      "fd42:e99e:1f58::1"
      "fd42:e99e:1f58:53::1"
    ];

    listenOn = [
      "172.23.181.161"
    ];

    zones = {
      "emma.dn42" = {
        master = true;
        file = ./emma.dn42;
      };
    };
  };
}