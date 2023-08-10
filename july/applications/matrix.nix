{
  pkgs,
  self,
  ...
}: let
  serverName = "boecker.dev";
  matrixDomain = "matrix.boecker.dev";
  clientConfig."m.homeserver".base_url = "https://${matrixDomain}";
  clientConfig."m.homeserver".server_name = "boecker.dev";
  clientConfig."m.identity_server".base_url = "https://vector.im";
  serverConfig."m.server" = "${matrixDomain}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
  # age.secrets.matrix-secret = {
  #   file = "${self}/secrets/matrix-secret.age";
  #   owner = "matrix-synapse";
  #   group = "matrix-synapse";
  # };

  uwumarie.reverse-proxy.services = {
    "${serverName}" = {
      locations."/" = {
        return = "301 https://www.boecker.dev$request_uri";
      };
      locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
      locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
    };
    "${matrixDomain}" = {
      locations."~ ^(/_matrix|/_synapse/client)" = {
        proxyPass = "http://[::1]:6167";
        extraConfig = ''
          client_max_body_size 50M;
          proxy_http_version 1.1;
        '';
      };
    };
  };

  services.matrix-conduit = {
    enable = true;

    package = self.inputs.conduit.packages.${pkgs.system}.default;

    settings.global = {
      server_name = serverName;
      port = 6167;
      max_request_size = 50000000;
      database_backend = "rocksdb";
      allow_registration = false;
      allow_federation = true;
      allow_encryption = true;
      trusted_servers = [ "matrix.org" "mozilla.org" ];
    };
  };

  services.postgresql = {
    ensureUsers = [
      {
        name = "mautrix-whatsapp";
        ensurePermissions = {
          "DATABASE \"mautrix-whatsapp\"" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = ["mautrix-whatsapp"];
  };

  services.mautrix-whatsapp = {
    enable = true;
    serviceDependencies = [
      "conduit.service"
    ];

    settings = {
      appservice = {
        database = {
          type = "postgres";
          uri = "postgresql:///mautrix-whatsapp?host=/run/postgresql";
        };
        ephemeral_events = false;
        id = "whatsapp";

        address = "http://localhost:29318";
        hostname = "0.0.0.0";
        port = 29318;
      };
      homeserver = {
        address = "https://matrix.boecker.dev:443";
        domain = "boecker.dev";
        software = "standard";
        async_media = false;
        websocket = false;
      };
      bridge = {
        encryption = {
          allow = true;
          default = true;
          require = true;
        };
        history_sync = {
          request_full_sync = true;
        };
        mute_bridging = true;
        permissions = {
          "boecker.dev" = "user";
          "@emma:boecker.dev" = "admin";
        };
        private_chat_portal_meta = true;
        provisioning = {
          shared_secret = "disable";
        };
      };
      metrics = {
        enabled = true;
        listen = "127.0.0.1:8918";
      };
    };
  };

  systemd.services.conduit = {
    after = ["network-online.target" "postgresql.service"];
    wants = ["network-online.target" "postgresql.service"];
  };


  services.prometheus.scrapeConfigs = [
    {
      job_name = "mautrix-whatsapp";
      metrics_path = "/metrics";
      static_configs = [
        {
          targets = ["127.0.0.1:8918"];
        }
      ];
    }
  ];
}
