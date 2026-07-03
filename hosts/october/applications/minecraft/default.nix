{ ... }: {
  networking.firewall.allowedTCPPorts = [
    25565
  ];

  imports = [
    ./cherrycave
  ];
}