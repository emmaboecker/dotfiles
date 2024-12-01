{ self, config, pkgs, ... }: {
  imports = [
    ./bird2.nix
    ./dns/bind.nix
    ./dns/dnsmasq.nix
  ];

  age.secrets.dn42-peer1.file = "${self}/secrets/wireguard/dn42/peer1-private.age";
  age.secrets.dn42-peer2.file = "${self}/secrets/wireguard/dn42/peer2-private.age";

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  networking = {
    firewall = {
      allowedUDPPorts = [
        51820
        51821
        51822
      ];
      
      checkReversePath = false;
      interfaces."dn42n*" = {
        allowedTCPPorts = [ 179 53 ];
        allowedUDPPorts = [ 53 ];
      };
    };

    firewall.trustedInterfaces = [ "wg0" ];
    interfaces.lo = {
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
        {
          address = "fd42:e99e:1f58:53::127";
          prefixLength = 128;
        }
      ];
    };

    wireguard.interfaces = {
      dn42n0 = { # Marie
        listenPort = 51821;
        allowedIPsAsRoutes = false;
        privateKeyFile = config.age.secrets.dn42-peer1.path; # 6IgFC2JAZ0xjZhDaH3YxpruFtMkoEPralJXzctBCnyA=

        ips = [
          "fe80::d119:602d:d206:e469/64"
        ];

        peers = [
          {
            publicKey = "iEb03LhZwbDxtp+LhskWrnV+GKR0cGHweQGN7P0zsg0=";
            allowedIPs = [ "::/0" ];
            endpoint = "2a03:4000:5f:f5b:::51821";
          }
        ];

      };
      # dn42n1 = { # g-load.eu
      #   listenPort = 51822;
      #   allowedIPsAsRoutes = false;
      #   privateKeyFile = config.age.secrets.dn42-peer2.path; # ED5B6y2f7Cml6dGspHVzXX2WiZbDOLiUvF93Op3Smlo=

      #   ips = [
      #     "fe80::b77a:3f66:db51:41ff/64"
      #   ];

      #   peers = [
      #     {
      #       publicKey = "B1xSG/XTJRLd+GrWDsB06BqnIq8Xud93YVh/LYYYtUY=";
      #       allowedIPs = [ "0.0.0.0/0" "::/0" ];
      #       endpoint = "de2.g-load.eu:23161";
      #     }
      #   ];

      #   postSetup = ''
      #       ${pkgs.iproute2}/bin/ip addr add 192.168.221.170/32 peer 172.20.53.97/32 dev dn42n1
      #   '';
      # };
    };
  };

  security.pki.certificateFiles = [ ./dn42-ca.pem ];
}