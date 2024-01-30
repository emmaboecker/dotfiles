let
  userKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIh+tAKie4OOkzxIwprEcQHiaL4ifkJKcSeN3bytV1rZ stckoverflw@gmail.com" # desktop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPiBYp+pjF/3Q6deVfH4uMqYg6y9YbK29qZ6kNyWLxil stckoverflw@gmail.com" # laptop
  ];

  systemKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8+tB44MHGTih2DlHeNpnEYE2ah6/OS6lwcJQTGwrae root@nixos";

  allKeys = userKeys ++ [systemKey];
in {
  "secrets/nextcloud-admin.age".publicKeys = allKeys;

  "secrets/iws-token.age".publicKeys = allKeys;
  "secrets/iws-rs.age".publicKeys = allKeys;
  "secrets/mongo-root.age".publicKeys = allKeys;

  "secrets/aufbaubot-deletions.age".publicKeys = allKeys;
  "secrets/aufbaubot-env.age".publicKeys = allKeys;

  "secrets/ris-tokens.age".publicKeys = allKeys;

  "secrets/matrix-secret.age".publicKeys = allKeys;
  "secrets/syncv3_secret.age".publicKeys = allKeys;

  "secrets/authentik-redis-password.age".publicKeys = allKeys;
  "secrets/authentik-secrets.age".publicKeys = allKeys;

  "secrets/grafana-oauth-secret.age".publicKeys = allKeys;

  "secrets/fivem-secrets.age".publicKeys = allKeys;
  
  "secrets/emmalink-test-password.age".publicKeys = allKeys;
  "secrets/emmalink-secrets.age".publicKeys = allKeys;

  "secrets/etog-modpack-secrets.age".publicKeys = allKeys;

  "secrets/wireguard/river-private.age".publicKeys = allKeys;
  "secrets/wireguard/dn42/peer1-private.age".publicKeys = allKeys;
  "secrets/wireguard/dn42/peer2-private.age".publicKeys = allKeys;
}
