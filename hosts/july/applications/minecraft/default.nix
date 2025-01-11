{ ... }: {
    networking.firewall.allowedTCPPorts = [  
      25565
      25521
    ];

  imports = [
    # ./bak-kk.nix
    # ./ljs-lsa.nix
    # ./uwu.nix
    ./ljs.nix
  ];
}