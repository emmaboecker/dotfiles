{...}: {
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  networking = {
    hostName = "july";

    nftables.enable = true;

    firewall.allowedTCPPorts = [
      22
      80
      443
    ];

    interfaces = {
      ens3 = {
        useDHCP = false;
        ipv6.addresses = [
          {
            address = "2a03:4000:47:251::";
            prefixLength = 64;
          }
          {
            address = "2a03:4000:47:251:e44a:b0ec:ce75:b00b";
            prefixLength = 128;
          }
          {
            address = "2a03:4000:47:251:626f:6563:6b65:723b";
            prefixLength = 128;
          }
        ];
        ipv4.addresses = [
          {
            address = "45.129.180.33";
            prefixLength = 22;
          }
        ];
      };
    };
    defaultGateway = {
      address = "45.129.180.1";
      interface = "ens3";
    };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    nameservers = [
      # Netcup
      "2a03:4000:0:1::e1e6"
      "2a03:4000:8000::fce6"
      "46.38.225.230"
      "46.38.252.230"
      # Cloudflare
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "1.1.1.1"
      "1.0.0.1"
      # Google
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.default.accept_ra"  = 0;
    "net.ipv6.conf.default.autoconf"   = 0;
    "net.ipv6.conf.all.accept_ra"      = 0;
    "net.ipv6.conf.all.autoconf"       = 0;
    "net.ipv6.conf.ens3.accept_ra"     = 0;
    "net.ipv6.conf.ens3.autoconf"      = 0;
  };
}
