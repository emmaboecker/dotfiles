{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox
    ungoogled-chromium
    spotify
    thunderbird
    jellyfin-desktop
    delfin
    plezy
    vlc

    affinity-v3

    libreoffice-qt-fresh
    hunspell
    hunspellDicts.de-de
    hunspellDicts.en-us

    obsidian

    mixxx

    chatterino7

    telegram-desktop
    signal-desktop
    fluffychat
    cinny-desktop
  ];

  programs.obs-studio = {
    enable = true;
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      obs-move-transition
      obs-composite-blur
      obs-advanced-masks
      obs-text-pthread
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-tuna
    ];
  };
}