{
  self,
  pkgs,
  config,
  trackerlist,
  ...
}:
{
  systemd.services.transmission = {
    after = [ "netns@vpn.target" ];
    bindsTo = [ "netns@vpn.target" ];
    serviceConfig = {
      NetworkNamespacePath = "/var/run/netns/vpn";
      BindReadOnlyPaths = "${config.vpn.dns.resolvconf}:/etc/resolv.conf:norbind";
      InaccessiblePaths = "/run/nscd/socket";
    };
  };

  systemd.services.transmission-proxy = {
    after = [
      "transmission.service"
      "netns@vpn.target"
    ];
    requires = [ "transmission.service" ];
    bindsTo = [ "netns@vpn.target" ];
    serviceConfig = {
      Type = "notify";
      NetworkNamespacePath = "/var/run/netns/vpn";
      ExecStart = "${config.systemd.package}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:9091";
    };
  };

  systemd.sockets.transmission-proxy = {
    listenStreams = [ "9091" ];
    wantedBy = [ "sockets.target" ];
  };

  systemd.services.transmission-nginx-credentials = {
    before = [ "nginx.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "rm /run/nginx-transmission-auth.conf";
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadOnlyPaths = "/run/agenix";
      ReadWritePaths = "/run";
      CapabilityBoundingSet = [
        "CAP_CHOWN"
        "CAP_FOWNER"
        "CAP_DAC_OVERRIDE"
      ];
      NoNewPrivileges = true;
      RestrictAddressFamilies = "none";
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      PrivateDevices = true;
      ProtectClock = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      SystemCallArchitectures = "native";
      MemoryDenyWriteExecute = true;
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      ProtectHostname = true;
      LockPersonality = true;
      RestrictRealtime = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      PrivateNetwork = true;
      PrivateTmp = true;
      SystemCallFilter = [ "@system-service" ];
      UMask = "177";
    };
    path = with pkgs; [
      jq
      coreutils
    ];
    script = ''
      PASSWORD=$(jq -r '."rpc-password"' /run/agenix/transmission)
      BASE64=$(echo -n "transmission:$PASSWORD" | base64 | tr -d '\n')
      TARGET_FILE="/run/nginx-transmission-auth.conf"

      touch "$TARGET_FILE"
      chmod 600 "$TARGET_FILE"
      chown nginx:nginx "$TARGET_FILE"

      echo "proxy_set_header Authorization \"Basic $BASE64\";" > "$TARGET_FILE"
    '';
  };

  services.nginx.virtualHosts."bt.boecker.dev".locations."/" = {
    proxyPass = "http://127.0.0.1:9091";
    proxyWebsockets = true;
    extraConfig = ''
      include /run/nginx-transmission-auth.conf;
    '';
  };

  age.secrets.transmission = {
    file = "${self}/secrets/media/transmission.age";
    owner = "media";
  };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;

    user = "media";
    group = "media";
    credentialsFile = config.age.secrets.transmission.path;

    settings = {
      incomplete-dir-enabled = false;

      rpc-authentication-required = true;
      rpc-username = "transmission";

      rpc-host-whitelist-enabled = false;
      rpc-whitelist-enabled = false;

      default-trackers = builtins.readFile "${trackerlist}/trackers_all.txt";

      port-forwarding-enabled = false;

      download-dir = "/mnt/media/downloads";

      idle-seeding-limit-enabled = false;
      ratio-limit-enabled = false;

      preallocation = false;
    };
  };

  systemd.tmpfiles.settings.transmission = {
    "/mnt/media/downloads".d = {
      group = "media";
      user = "media";
      mode = "2770";
    };
  };
}
