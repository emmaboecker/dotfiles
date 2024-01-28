{self, config, pkgs, ...}: {
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  age.secrets.dn42-peer1.file = "${self}/secrets/wireguard/dn42/peer1-private.age";

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  networking = {
    hostName = "july";

    nftables = {
      enable = true;
      tables.forwarding = {
        family = "inet";
        content = ''
          chain forward {
            type filter hook forward priority 0; policy drop;

            iifname "dn42n*" oifname "dn42n*" accept
          }
        '';
      };
    };

    firewall.interfaces."dn42n*".allowedTCPPorts = [ 179 ];

    firewall.allowedTCPPorts = [
      22
      80
      443
      25565
      30120
    ];

    firewall.allowedUDPPorts = [
      24454
      30120
      51821
    ];

    firewall.checkReversePath = false;

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
      lo = {
        ipv4.addresses = [
          {
            address = "172.23.181.161";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "fd42:e99e:1f58::1";
            prefixLength = 128;
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

    wireguard.interfaces = {
      dn42n0 = { # Marie
        listenPort = 51821;
        allowedIPsAsRoutes = false;
        privateKeyFile = config.age.secrets.dn42-peer1.path; # 6IgFC2JAZ0xjZhDaH3YxpruFtMkoEPralJXzctBCnyA=

        peers = [
          {
            publicKey = "iEb03LhZwbDxtp+LhskWrnV+GKR0cGHweQGN7P0zsg0=";
            allowedIPs = [ "::/0" ];
            endpoint = "2a03:4000:5f:f5b:::51821";
          }
        ];

        postSetup = ''
            ${pkgs.iproute}/bin/ip -6 addr add fe80::d119:602d:d206:e469/64 dev dn42n0
        '';
      };
    };
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
