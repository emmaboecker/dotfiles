{ pkgs, ... }: {
  nix.package = pkgs.lixPackageSets.latest.lix; 

  nix.settings.experimental-features = [ "nix-command" "flakes" "flake-self-attrs" ];

  environment.systemPackages = with pkgs; [
    git
    btop
    dig
    wget 
    btop
  ];

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations +3";
  };
}