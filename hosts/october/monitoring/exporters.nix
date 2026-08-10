{ ... }:
{
  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [
        "systemd"
      ];
      port = 9002;
    };
  };

  services.journald.upload = {
    enable = false;
    settings.Upload.URL = "http://july:9428/insert/journald";
  };
}
