{ config, self, ... }: {

  services.victoriametrics = {
    enable = true;
    retentionPeriod = "1";

    prometheusConfig = {
      global.scrape_interval = "10s";
      scrape_configs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets = [ 
                "localhost:${toString config.services.prometheus.exporters.node.port}" 
                "october:9002"
              ];
            }
          ];
        }
        {
          job_name = "victorialogs";
          static_configs = [
            {
              targets = [ 
                "http://localhost:9428/metrics"
              ];
            }
          ];
        }
        {
          job_name = "nginx";
          static_configs = [
            {
              targets = [ 
                "localhost:${toString config.services.prometheus.exporters.nginx.port}"
              ];
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
  };
}
