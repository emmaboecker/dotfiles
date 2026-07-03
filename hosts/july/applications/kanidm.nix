{ config, pkgs, ... }:
let
  idm_domain = "idm.boecker.dev";
in
{
  services.kanidm = {
    package = pkgs.kanidm_1_10;

    server = {
      enable = true;
      settings = {
        domain = "${idm_domain}";
        origin = "https://${idm_domain}";
        bindaddress = "[::]:8443";

        tls_chain = "/var/lib/acme/${idm_domain}/fullchain.pem";
        tls_key = "/var/lib/acme/${idm_domain}/key.pem";
      };
    };

    client.enable = true;
    client.settings = {
      uri = "https://${idm_domain}";
    };
  };

  security.acme.certs."${idm_domain}" = {
    group = "kanidm";
  };

  services.nginx.virtualHosts."${idm_domain}" = {
    locations."/" = {
      proxyPass = "https://${toString config.services.kanidm.server.settings.bindaddress}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_ssl_verify on;
        proxy_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;
        proxy_ssl_name ${idm_domain};
      '';
    };
  };
}
