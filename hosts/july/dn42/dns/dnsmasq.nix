{ ... }: {
  services.dnsmasq = {
    enable = true;

    settings = {
      bind-interfaces = true;
      interface = [
        "wg0"
      ];
      except-interface= "lo";
      listen-address = ["127.0.0.1" "fd42:e99e:1f58:53::127"];

      server = [
        "/dn42/172.20.0.53"
        "/20.172.in-addr.arpa/172.20.0.53"
        "/21.172.in-addr.arpa/172.20.0.53"
        "/22.172.in-addr.arpa/172.20.0.53"
        "/23.172.in-addr.arpa/172.20.0.53"
        "/10.in-addr.arpa/172.20.0.53"
        "/d.f.ip6.arpa/fd42:d42:d42:54::1"
      ];
    };
  };
}