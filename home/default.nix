{ pkgs, ... }: {
  imports = [
    ./zsh.nix
  ];

  programs.home-manager.enable = true;

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    discord
    spotify

    rnix-lsp

    git
    just
  ];
}