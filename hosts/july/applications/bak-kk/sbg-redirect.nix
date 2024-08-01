{ ... }:
{
  services.nginx.virtualHosts."sbg.bak.red" = {
    useACMEHost = "bak.red";
    locations."/" = {
      return = "301 https://selbst.aprilthe.pink$request_uri";
    };
  };
}