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

  age.secrets.river-private.file = "${self}/secrets/wireguard/river-private.age";
  age.secrets.dn42-peer1.file = "${self}/secrets/wireguard/dn42/peer1-private.age";
  age.secrets.dn42-peer2.file = "${self}/secrets/wireguard/dn42/peer2-private.age";

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
            tcp dport 53 accept
            udp dport 53 accept
            iifname "wg0" accept
            ct state { established, related } accept
          }
        '';
      };
    };

    firewall.interfaces."dn42n*".allowedTCPPorts = [ 179 53 ];
    firewall.interfaces."dn42n*".allowedUDPPorts = [ 53 ];

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
      51820
      51821
      51822
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
                    {
            address = "fd42:e99e:1f58:53::1";
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
      wg0 = {
        listenPort = 51820;
        allowedIPsAsRoutes = false;
        privateKeyFile = config.age.secrets.river-private.path; # eI5GGnHzyY/9DKc73Ix0uCWmpOtZLo7h0gJcI2HiQjc=

        peers = [
          {
            publicKey = "TKnru4+eIKssDDOlrpQKtrWOB7Cf+4mj3il2SevqxBo=";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
          }
        ];
      };
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
      dn42n1 = { # g-load.eu
        listenPort = 51822;
        allowedIPsAsRoutes = false;
        privateKeyFile = config.age.secrets.dn42-peer2.path; # ED5B6y2f7Cml6dGspHVzXX2WiZbDOLiUvF93Op3Smlo=

        peers = [
          {
            publicKey = "B1xSG/XTJRLd+GrWDsB06BqnIq8Xud93YVh/LYYYtUY=";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            endpoint = "de2.g-load.eu:23161";
          }
        ];

        postSetup = ''
            ${pkgs.iproute}/bin/ip -6 addr add fe80::b77a:3f66:db51:41ff/64 dev dn42n1
            ${pkgs.iproute}/bin/ip addr add 192.168.221.170/32 peer 172.20.53.97/32 dev dn42n1
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
