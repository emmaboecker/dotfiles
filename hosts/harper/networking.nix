{ lib, ...}: {
  networking = {
    hostName = "harper";

    useDHCP = lib.mkDefault true;
    nftables.enable = true;

    networkmanager = {
      enable = true;
      firewallBackend = "nftables";
    };

    firewall = {
      enable = true;
      allowedUDPPorts = [ 22 ];
    };
    nameservers = [
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
