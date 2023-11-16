{
  pkgs,
  self,
  config,
  ...
}: let
  serverName = "boecker.dev";
  matrixDomain = "matrix.boecker.dev";

  clientConfig."m.homeserver".base_url = "https://${matrixDomain}";
  clientConfig."m.homeserver".server_name = "boecker.dev";
  clientConfig."m.identity_server".base_url = "https://vector.im";
  clientConfig."org.matrix.msc3575.proxy".url = "https://${matrixDomain}";

  serverConfig."m.server" = "${matrixDomain}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
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

          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
        '';
      };
      locations."~ ^/(client/|_matrix/client/unstable/org.matrix.msc3575/sync)" = {
        proxyPass = "http://localhost:6168";
        extraConfig = ''
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
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

  systemd.services.conduit = {
    after = ["network-online.target"];
    wants = ["network-online.target"];
  };

  # age.secrets.syncv3_secret.file = "${self}/secrets/syncv3_secret.age";

  # virtualisation.oci-containers.containers.sliding-sync-proxy = {
  #   image = "ghcr.io/matrix-org/sliding-sync:latest";

  #   environmentFiles = [
  #     config.age.secrets.syncv3_secret.path
  #   ];

  #   environment = {
  #     SYNCV3_SERVER = "http://localhost:6167";
  #     SYNCV3_DB = "postgresql:///syncv3?host=/run/postgresql";
  #     SYNCV3_BINDADDR = "0.0.0.0:6168";
  #   };

  #   extraOptions = ["--network=host"];
  # };

  # systemd.services.podman-sliding-sync-proxy = {
  #   after = ["postgresql.service" "matrix-conduit.service"];
  #   wants = ["postgresql.service" "matrix-conduit.service"];
  # };

  services.postgresql = {
    ensureDatabases = ["syncv3"];
  };
}
