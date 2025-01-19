{ ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  services.home-assistant = {
    enable = true;

    extraPackages = python3Packages: with python3Packages; [
      fritzconnection
      aioelectricitymaps
      govee-ble
      gassist-text
      grpcio
      pychromecast
      nextcord
      spotipy
    ];

    config = null;
  };

  services.nginx.tailscaleAuth = {
    enable = true;
    virtualHosts = ["hass.boecker.dev"];
  };
  services.nginx.virtualHosts."hass.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://localhost:8123";
      proxyWebsockets = true;
    };
  };
}