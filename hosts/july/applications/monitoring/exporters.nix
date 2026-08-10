{ self, config, ... }: {
  age.secrets.fritz-password = {
    file = "${self}/secrets/fritzbox/fritz-password.age";
    owner = config.services.prometheus.exporters.fritz.user;
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [
        "systemd"
      ];
      port = 9002;
    };
    fritz = {
      enable = true;
      settings.devices = [
        {
          name = "le";
          hostname = "192.168.161.2";
          username = "fritz5804";
          password_file = config.age.secrets.fritz-password.path;
        }
      ];
    };
    nginx = {
      enable = true;
      scrapeUri = "http://localhost/stub_status";
      sslVerify = false;
    };
  };

  services.journald.upload = {
    enable = false;
    settings.Upload.URL = "http://localhost:9428/insert/journald";
  };
}