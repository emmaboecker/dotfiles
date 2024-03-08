{ self, config, ...}: {
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

    nftables = {
      enable = true;
      tables.forwarding = {
        family = "inet";
        content = ''
          chain forward {
            type filter hook forward priority 0; policy drop;

            iifname "dn42n*" oifname "dn42n*" accept
            iifname "dn42n*" oifname "wg0" tcp dport 25565 accept
            iifname "wg0" accept
            ct state { established, related } accept
          }
        '';
      };
    };
    
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

    wireguard.interfaces = {
      wg0 = {
        listenPort = 51820;
        allowedIPsAsRoutes = false;
        privateKeyFile = config.age.secrets.river-private.path; # eI5GGnHzyY/9DKc73Ix0uCWmpOtZLo7h0gJcI2HiQjc=

        ips = [
          "fd42:e99e:1f58:0127::1/64"
          "172.23.181.161/24"
          "10.161.0.1/24"
        ];

        peers = [
          { # desktop
            name = "river";
            publicKey = "TKnru4+eIKssDDOlrpQKtrWOB7Cf+4mj3il2SevqxBo=";
            allowedIPs = [ "fd42:e99e:1f58:0127::2/128" "172.23.181.162/32" "10.161.0.2/32" ];
            persistentKeepalive = 25;
          }
          { # note 10+
            name = "note";
            publicKey = "4Fn/RsVriuvfDBo/c8QyjrXW19FRrATYbitptC+ibT8=";
            allowedIPs = [ "fd42:e99e:1f58:0127::3/128" "172.23.181.163/32" "10.161.0.3/32" ];
            persistentKeepalive = 25;
          }
        ];
      };
      wg1 = {
        allowedIPsAsRoutes = false;
        privateKeyFile = config.age.secrets.fritz-private.path;

        ips = [
          "192.168.178.201/24"
        ];

        peers = [
          { # home fritzbox
            name = "fritz-home";
            publicKey = "1DmvSMbkh+qiivD5mdQShKrfFV6mzJIWemJmTq7f6RM=";
            presharedKey = "+z2Ditg3KrDejJ7g5nR/K+n63/op3aTbp/W5M/CKULw=";
            allowedIPs = [ "192.168.178.0/24" ];
            endpoint = "asj4ixwav1fgmbmj.myfritz.net:50021";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  age.secrets.river-private.file = "${self}/secrets/wireguard/river-private.age";
  age.secrets.fritz-private.file = "${self}/secrets/wireguard/fritz-private.age";
    
  boot.kernel.sysctl = {
    "net.ipv6.conf.default.accept_ra"  = 0;
    "net.ipv6.conf.default.autoconf"   = 0;
    "net.ipv6.conf.all.accept_ra"      = 0;
    "net.ipv6.conf.all.autoconf"       = 0;
    "net.ipv6.conf.ens3.accept_ra"     = 0;
    "net.ipv6.conf.ens3.autoconf"      = 0;
  };
}
