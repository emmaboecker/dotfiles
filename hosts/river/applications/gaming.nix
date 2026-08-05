{ pkgs, maccel, ...}: {
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  programs.steam = {
    enable = true;
    extest.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    heroic
    (pkgs.prismlauncher.override {
      additionalLibs = with pkgs; [ 
        libxkbcommon
        libX11
        libXtst
        libXext
      ];
    })
    waywall
    lunar-client
  ];

  users.groups.maccel.members = ["lou"];
}