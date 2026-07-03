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

  age.secrets.grafana-secret-key = {
    file = "${self}/secrets/grafana-secret-key.age";
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
        disable_login_form = false;
      };
      "auth.generic_oauth" = {
        enabled = true;
        name = "Kanidm";
        auto_login = true;
        client_id = "grafana";
        client_secret = "$__file{${config.age.secrets.grafana-oauth-secret.path}}";
        scopes = "profile email openid groups";
        auth_url = "https://idm.boecker.dev/ui/oauth2";
        token_url = "https://idm.boecker.dev/oauth2/token";
        api_url = "https://idm.boecker.dev/oauth2/openid/grafana/userinfo";
        use_pkce = true;
        login_attribute_path = "preferred_username";
        name_attribute_path = "nickname";

        role_attribute_path = "contains(grafana_role[*], 'GrafanaAdmin') && 'GrafanaAdmin' || contains(grafana_role[*], 'Admin') && 'Admin' || contains(grafana_role[*], 'Editor') && 'Editor' || 'Viewer'";
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
        secret_key = "$__file{${config.age.secrets.grafana-secret-key.path}}";
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
        # {
        #   name = "Loki";
        #   type = "loki";
        #   access = "proxy";
        #   url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        # }
      ];
    };
  };

  services.nginx.virtualHosts."grafana.boecker.dev" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };
}
