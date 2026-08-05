let
  userKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIh+tAKie4OOkzxIwprEcQHiaL4ifkJKcSeN3bytV1rZ" # desktop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPiBYp+pjF/3Q6deVfH4uMqYg6y9YbK29qZ6kNyWLxil" # laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9JOPOwuT4iHyB7x9OOsLmQMA8sLFPVisuvIyRmvJe5" # laptop
  ];

  systemKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8+tB44MHGTih2DlHeNpnEYE2ah6/OS6lwcJQTGwrae root@nixos" # july
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJuh9PuiBBVeskbUDgsrt7J9VLCbIv94yA2DyNBA2Nqn" # june
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID70NYMyddPOhI7o8fdPFQunB0ZQemZ/iN9lz/TeWvRF" # october
  ];

  allKeys = userKeys ++ systemKeys;
in {
  "secrets/cloudflare-api-key.age".publicKeys = allKeys;
  "secrets/cloudflare-email.age".publicKeys = allKeys;

  "secrets/nextcloud-admin.age".publicKeys = allKeys;

  "secrets/ris-tokens.age".publicKeys = allKeys;

  # "secrets/matrix-secret.age".publicKeys = allKeys;
  # "secrets/syncv3_secret.age".publicKeys = allKeys;
  "secrets/matrix/tuwunel-config.age".publicKeys = allKeys;

  "secrets/authentik-redis-password.age".publicKeys = allKeys;
  "secrets/authentik-secrets.age".publicKeys = allKeys;

  "secrets/grafana-oauth-secret.age".publicKeys = allKeys;
  "secrets/grafana-secret-key.age".publicKeys = allKeys;

  "secrets/fivem-secrets.age".publicKeys = allKeys;
  
  "secrets/emmalink-test-password.age".publicKeys = allKeys;
  "secrets/emmalink-secrets.age".publicKeys = allKeys;

  "secrets/etog-modpack-secrets.age".publicKeys = allKeys;

  "secrets/wireguard/river-private.age".publicKeys = allKeys;
  "secrets/wireguard/fritz-private.age".publicKeys = allKeys;
  "secrets/wireguard/fritz-preshared-key.age".publicKeys = allKeys;
  "secrets/wireguard/dn42/peer1-private.age".publicKeys = allKeys;
  "secrets/wireguard/dn42/peer2-private.age".publicKeys = allKeys;

  "secrets/fritzbox/fritz-password.age".publicKeys = allKeys;

  "secrets/tailscale/tailscale-auth-key.age".publicKeys = allKeys;
  "secrets/tailscale/june/tailscale-auth-key.age".publicKeys = allKeys;

  "secrets/paperless-env.age".publicKeys = allKeys;
  
  "secrets/bak-kk/links-secrets.age".publicKeys = allKeys;

  "secrets/samba/test-samba-credentials.age".publicKeys = allKeys;
  "secrets/samba/nextcloud-samba-credentials.age".publicKeys = allKeys;
  "secrets/samba/files-samba-credentials.age".publicKeys = allKeys;
  "secrets/samba/media-samba-credentials.age".publicKeys = allKeys;

  "secrets/copyparty/copyparty-lou-password.age".publicKeys = allKeys;

  "secrets/media/media-vpn-wg.age".publicKeys = allKeys;
  "secrets/media/transmission.age".publicKeys = allKeys;
  "secrets/media/oauth2-proxy.age".publicKeys = allKeys;
  "secrets/media/tmdb-api-key.age".publicKeys = allKeys;

  "secrets/cherrycave/luckperms-standalone-env.age".publicKeys = allKeys;
  "secrets/cherrycave/velocity-forwarding-secret.age".publicKeys = allKeys;
  "secrets/cherrycave/rabbitmq-env.age".publicKeys = allKeys;

  "secrets/vaultwarden-secrets.age".publicKeys = allKeys;
  "secrets/vaultwarden-backup-password.age".publicKeys = allKeys;
}
