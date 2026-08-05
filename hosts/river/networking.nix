{ pkgs, ...}: {
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [ networkmanager-openconnect ];
  networking.firewall.enable = false;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
}