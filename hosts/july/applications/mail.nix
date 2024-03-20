{ mailserver, self, config,  ... }: {
  imports = [
    mailserver.nixosModules.default
  ];

  age.secrets.emma-boecker-dev-password.file = "${self}/secrets/mail/emma-boecker-dev-password.age";

  services.dovecot2.sieve.extensions = [ "fileinto" ];

  services.postfix.submissionOptions = {
  };

  mailserver = {
    enable = true;
    fqdn = "mail.boecker.dev";
    domains = [ "boecker.dev" ];
    localDnsResolver = false;
    certificateScheme = "acme";
  
    loginAccounts = {
      "emma@boecker.dev" = {
        hashedPasswordFile = config.age.secrets.emma-boecker-dev-password.path;
        aliases = ["postmaster@boecker.dev"];
      };
    };
  };
}