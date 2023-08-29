{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./gnome-keyring.nix
  ];

  programs.home-manager.enable = true;

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    discord
    spotify
    signal-desktop
    fluffychat
    telegram-desktop

    vscode

    gnome.gnome-tweaks

    rnix-lsp

    git
    just
  ];
}
