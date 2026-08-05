{ pkgs, agenix, colmena, ... }:
{
  environment.systemPackages = with pkgs; [
    vscode
    git
    jujutsu
    nixfmt
    jdk25
    mitmproxy

    bruno

    android-tools

    jetbrains-toolbox

    wl-clipboard
  ] ++ [
    agenix.packages.x86_64-linux.default 
    colmena.packages.x86_64-linux.colmena
  ];

  virtualisation.waydroid.enable = true;

  users.users.lou.extraGroups = ["adbusers"];

  programs.direnv.enable = true;
}
