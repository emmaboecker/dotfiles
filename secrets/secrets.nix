let
  userKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIh+tAKie4OOkzxIwprEcQHiaL4ifkJKcSeN3bytV1rZ stckoverflw@gmail.com" # desktop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPiBYp+pjF/3Q6deVfH4uMqYg6y9YbK29qZ6kNyWLxil stckoverflw@gmail.com" # laptop
  ];

  systemKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8+tB44MHGTih2DlHeNpnEYE2ah6/OS6lwcJQTGwrae root@nixos";

  allKeys = userKeys ++ [systemKey];
in {
  "nextcloud-admin.age".publicKeys = allKeys;

  "iws-token.age".publicKeys = allKeys;
  "iws-rs.age".publicKeys = allKeys;
  "mongo-root.age".publicKeys = allKeys;

  "ris-tokens.age".publicKeys = allKeys;

  "matrix-secret.age".publicKeys = allKeys;

  "authentik-redis-password.age".publicKeys = allKeys;
  "authentik-secrets.age".publicKeys = allKeys;

  "grafana-oauth-secret.age".publicKeys = allKeys;
}
