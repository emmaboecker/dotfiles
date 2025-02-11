{ ... }:
{
  services.changedetection-io = {
    enable = true;

    baseURL = "changes.boecker.dev";
    behindProxy = true;
  };

  services.nginx.tailscaleAuth = {
    enable = true;
    virtualHosts = ["changes.boecker.dev"]; 
  };

  services.nginx.virtualHosts."changes.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:5000";
    };
  };
}