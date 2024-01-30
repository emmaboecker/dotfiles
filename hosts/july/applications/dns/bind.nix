{ ... }: {

  services.bind = {
    enable = true;

    zones = {
      "emma.dn42" = {
        master = true;
        file = ./emma.dn42;
      };
    };

    extraConfig = ''
      zone "dn42" {
        type forward;
        forward only;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "20.172.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "21.172.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "22.172.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "23.172.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "10.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
      zone "d.f.ip6.arpa" {
        type forward;
        forward only;
        forwarders { 172.20.0.53; fd42:d42:d42:54::1; };
      };
    '';

    extraOptions = ''
      empty-zones-enable no;

      validate-except {
        "dn42";
        "20.172.in-addr.arpa";
        "21.172.in-addr.arpa";
        "22.172.in-addr.arpa";
        "23.172.in-addr.arpa";
        "10.in-addr.arpa";
        "d.f.ip6.arpa";
      };
    '';
  };
}