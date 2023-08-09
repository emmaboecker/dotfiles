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

  # services.postgresql = {
  #   ensureUsers = [
  #     {
  #       name = "matrix-synapse";
  #       ensurePermissions = {
  #         "DATABASE \"matrix-synapse\"" = "ALL PRIVILEGES";
  #       };
  #     }
  #   ];
  #   ensureDatabases = ["matrix-synapse"];
  # };



  # services.matrix-synapse = {
  #   enable = true;
  #   settings = {
  #     server_name = serverName;
  #     enable_registration = false;
  #     public_baseurl = "https://${matrixDomain}/";

  #     enable_metrics = true;

  #     database = {
  #       name = "psycopg2";
  #       args = {
  #         # Bug in NixOS module this only triggers that the local db is used
  #         host = "127.0.0.1";
  #         database = "matrix-synapse";
  #         user = "matrix-synapse";
  #       };
  #     };
  #     listeners = [
  #       {
  #         port = 8008;
  #         bind_addresses = ["::1"];
  #         type = "http";
  #         tls = false;
  #         x_forwarded = true;
  #         resources = [
  #           {
  #             names = ["client" "federation"];
  #             compress = false;
  #           }
  #         ];
  #       }
  #       {
  #         port = 8009;
  #         bind_addresses = ["127.0.0.1" "::1"];
  #         type = "http";
  #         tls = false;
  #         x_forwarded = true;
  #         resources = [
  #           {
  #             names = ["metrics"];
  #             compress = false;
  #           }
  #         ];
  #       }
  #     ];
  #   };
  #   extraConfigFiles = [
  #     (pkgs.writeText
  #       "postgres.yaml"
  #       ''
  #         database:
  #           name: psycopg2
  #           args:
  #             host: /run/postgresql
  #             database: matrix-synapse
  #             user: matrix-synapse
  #       '')
  #     config.age.secrets.matrix-secret.path
  #   ];
  # };

  # systemd.services.matrix-synapse = {
  #   after = ["network-online.target" "postgresql.service"];
  #   wants = ["network-online.target" "postgresql.service"];
  # };

  # services.prometheus.scrapeConfigs = [
  #   {
  #     job_name = "matrix-synapse";
  #     metrics_path = "/_synapse/metrics";
  #     static_configs = [
  #       {
  #         targets = ["localhost:8009"];
  #       }
  #     ];
  #   }
  # ];
}