{ config, self, ... }: {
  age.secrets.fritz-password = {
    file = "${self}/secrets/fritzbox/fritz-password.age";
    owner = config.services.prometheus.exporters.fritz.user;
  };

  services.prometheus = {
    enable = true;
    retentionTime = "30d";

    globalConfig.scrape_interval = "20s";

    exporters = {
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
    };

    scrapeConfigs = [
      {
        job_name = "july";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "june";
        static_configs = [
          {
            targets = [ "june:9002" ];
          }
        ];
      }
      {
        job_name = "fritzbox";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.fritz.port}" ];
          }
        ];
      }
    ];
  };
}
