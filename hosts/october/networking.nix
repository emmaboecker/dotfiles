{ ... }: {
  networking = {
    hostName = "october";

    nftables = {
      enable = true;
    };
    
    firewall.allowedTCPPorts = [
      22
      80
      443
    ];

    firewall.allowedUDPPorts = [];
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-ens3" = {
        name = "ens3";
        DHCP = "no";
        address = [
          "85.190.101.91/24"
          "2001:880:0:23::1/64"
        ];
        routes = [
          { Gateway = "85.190.101.1"; }
          { Gateway = "fe80::1"; }
        ];
        networkConfig = {
          KeepConfiguration = "yes";
          IPv6AcceptRA = false;
        };
      };
    };
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  # services.fail2ban = {
  #   enable = true;
  #   ignoreIP = [
  #     "10.69.0.0/24"
  #     "127.0.0.1/8"
  #     "100.64.0.0/10"
  #   ];
  #   bantime-increment = {
  #     enable = true;
  #     maxtime = "48h";
  #     overalljails = true;
  #     rndtime = "1h";
  #   };
  #   bantime = "1h";
  #   maxretry = 5;
  #   jails = {
  #     sshd = {
  #       enabled = true;
  #       settings = {
  #         mode = "aggressive";
  #       };
  #     };
  #   };
  # };
}