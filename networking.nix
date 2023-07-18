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

    firewall.allowedTCPPorts = [
      22
      80
      443
    ];
  };
}
