{ pkgs, ... }: {
  imports = [
    ./zsh.nix
  ];

  programs.home-manager.enable = true;

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    discord
    spotify
    signal-desktop
    fluffychat
    telegram-desktop

    gnome.gnome-tweaks

    rnix-lsp

    git
    just
  ];
}
