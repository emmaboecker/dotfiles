{ config, ... }:
{
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
    };

    scrapeConfigs = [
      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
    ];
  };
}