{ pkgs, ...}: {
  services.ringboard.wayland.enable = true;

  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    pulsemeeter
    nextcloud-client
    scrcpy
    xdg-utils 
    qpwgraph
    appimage-run
    gparted
    woeusb
    sbctl
    ffmpeg-full
    solaar
    ngrok
    yt-dlp
    net-tools
    mtr
    openrgb
    pixelorama

    openconnect
  ] ++ (with pkgs.kdePackages; [
      isoimagewriter
      gwenview
      karp
      kdenlive
      glaxnimate
  ]);

  programs.kdeconnect.enable = true;

  services.flatpak.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libxkbcommon
      libxtst
      libx11
      libxext
      libxi
      libxt
      
      wayland
      libglvnd
      glfw3-minecraft
    ];
  };  
}