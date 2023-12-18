{
  self,
  config,
  ...
}: {
  age.secrets.grafana-oauth-secret = {
    file = "${self}/secrets/grafana-oauth-secret.age";
    owner = "grafana";
    group = "grafana";
  };

  services.postgresql = {
    ensureDatabases = ["grafana"];
    ensureUsers = [{
      name = "grafana";
      ensureDBOwnership = true;
    }];
  };

  services.grafana = {
    enable = true;
    settings = {
      auth = {
        disable_login_form = true;
        signout_redirect_url = "https://sso.boecker.dev/if/session-end/grafana/";
      };
      "auth.generic_oauth" = {
        enabled = true;
        name = "Authentik";
        auto_login = true;
        client_id = "gDkmJmAJbzewp42t4CAafUcU9KbHuRV6xl21GlPp";
        client_secret = "$__file{${config.age.secrets.grafana-oauth-secret.path}}";
        scopes = "profile email openid";
        auth_url = "https://sso.boecker.dev/application/o/authorize/";
        token_url = "https://sso.boecker.dev/application/o/token/";
        api_url = "https://sso.boecker.dev/application/o/userinfo/";

        role_attribute_path = "contains(groups[*], 'grafana-admin') && 'GrafanaAdmin' || contains(groups[*], 'grafana-editor') && 'Editor' || 'Viewer'";
        allow_assign_grafana_admin = true;
      };

      database = {
        type = "postgres";
        host = "/var/run/postgresql/";
        name = "grafana";
        user = "grafana";
      };

      security = {
        disable_initial_admin_creation = true;
        cookie_secure = true;
      };

      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "grafana.boecker.dev";
        root_url = "https://grafana.boecker.dev";
      };
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus july";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        }
      ];
    };
  };

  uwumarie.reverse-proxy.services = {
    "grafana.boecker.dev" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
      };
    };
  };
}
