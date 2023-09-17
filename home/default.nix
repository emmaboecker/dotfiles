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
    obsidian
    thunderbird

    nextcloud-client

    vscode

    gnome.gnome-tweaks

    rnix-lsp

    rustup
    gcc
    cmake
    gnumake

    pkg-config
    
    openssl.dev

    git
    git-lfs
    just
  ];
}
