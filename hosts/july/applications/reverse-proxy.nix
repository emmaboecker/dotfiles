{ self, lib, config, ... }: {
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      config.forceSSL = lib.mkDefault true;
      config.http2 = lib.mkDefault true;
      config.useACMEHost = lib.mkDefault "boecker.dev";
    });
  };

  config = {
    services.nginx = {
      virtualHosts."_" = {
        default = true;
        locations."/" = {
          return = "404";
        };
      };
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;
      recommendedZstdSettings = true;
      recommendedProxySettings = true;

      commonHttpConfig = ''
        log_format json_analytics escape=json '{'
          '"msec": "$msec", ' # request unixtime in seconds with a milliseconds resolution
          '"connection": "$connection", ' # connection serial number
          '"connection_requests": "$connection_requests", ' # number of requests made in connection
          '"pid": "$pid", ' # process pid
          '"request_id": "$request_id", ' # the unique request id
          '"request_length": "$request_length", ' # request length (including headers and body)
          '"remote_addr": "$remote_addr", ' # client IP
          '"remote_user": "$remote_user", ' # client HTTP username
          '"remote_port": "$remote_port", ' # client port
          '"time_local": "$time_local", '
          '"time_iso8601": "$time_iso8601", ' # local time in the ISO 8601 standard format
          '"request": "$request", ' # full path no arguments if the request
          '"request_uri": "$request_uri", ' # full path and arguments if the request
          '"args": "$args", ' # args
          '"status": "$status", ' # response status code
          '"body_bytes_sent": "$body_bytes_sent", ' # the number of body bytes exclude headers sent to a client
          '"bytes_sent": "$bytes_sent", ' # the number of bytes sent to a client
          '"http_referer": "$http_referer", ' # HTTP referer
          '"http_user_agent": "$http_user_agent", ' # user agent
          '"http_x_forwarded_for": "$http_x_forwarded_for", ' # http_x_forwarded_for
          '"http_host": "$http_host", ' # the request Host: header
          '"server_name": "$server_name", ' # the name of the vhost serving the request
          '"request_time": "$request_time", ' # request processing time in seconds with msec resolution
          '"upstream": "$upstream_addr", ' # upstream backend server for proxied requests
          '"upstream_connect_time": "$upstream_connect_time", ' # upstream handshake time incl. TLS
          '"upstream_header_time": "$upstream_header_time", ' # time spent receiving upstream headers
          '"upstream_response_time": "$upstream_response_time", ' # time spend receiving upstream body
          '"upstream_response_length": "$upstream_response_length", ' # upstream response length
          '"upstream_cache_status": "$upstream_cache_status", ' # cache HIT/MISS where applicable
          '"ssl_protocol": "$ssl_protocol", ' # TLS protocol
          '"ssl_cipher": "$ssl_cipher", ' # TLS cipher
          '"scheme": "$scheme", ' # http or https
          '"request_method": "$request_method", ' # request method
          '"server_protocol": "$server_protocol", ' # request protocol, like HTTP/1.1 or HTTP/2.0
          '"pipe": "$pipe", ' # "p" if request was pipelined, "." otherwise
          '"gzip_ratio": "$gzip_ratio", '
          '"http_cf_ray": "$http_cf_ray",'
        '}';

        access_log /var/log/nginx/json_access.log json_analytics;
      '';
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "emma@boecker.dev";
        dnsProvider = "cloudflare";
        dnsPropagationCheck = true;
        credentialsFile = config.age.secrets.cloudflare-api-key.path;
        # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      };
      certs."boecker.dev" = {
        domain = "*.boecker.dev";
        extraDomainNames = [
          "boecker.dev"
          "*.rail.boecker.dev"
        ];
      };
    };

    systemd.services."acme-boecker.dev-start".wants = [ "bind.service" "dnsmasq.service" ];

    users.users.nginx.extraGroups = [ "acme" ];
    age.secrets.cloudflare-api-key.file = "${self}/secrets/cloudflare-api-key.age";
  };
}
