{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hosts/river
      ./common.nix
    ];

  boot.loader.systemd-boot.enable = false;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "river";

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    useXkbConfig = true; 
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
  };

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  environment.systemPackages = with pkgs; [
    catppuccin-kde
  ];

  services.xserver.xkb.layout = "de";

  services.pipewire = {
     enable = true;
     pulse.enable = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [
    pkgs.libva-vdpau-driver
    pkgs.nvidia-vaapi-driver
  ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
  };

  boot.initrd.availableKernelModules = [
    "nvidia_drm" "nvidia_modeset" "nvidia" "nvidia_uvm"
  ];

  system.stateVersion = "25.11"; 
}

