{marie, ...}: {
  imports = [
    "${marie}/modules/reverse-proxy.nix"
  ];
  uwumarie.reverse-proxy = {
    enable = true;
    commonOptions = {
      forceSSL = true;
      http2 = true;
      enableACME = true;
    };
    services."_" = {
      default = true;
      enableACME = false;
      forceSSL = false;
      locations."/" = {
        return = "404";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "stckoverflw@gmail.com";
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;
    recommendedZstdSettings = true;
    recommendedProxySettings = true;
  };
}
