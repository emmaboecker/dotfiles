{ ... }:
{
  users.users.emma = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIh+tAKie4OOkzxIwprEcQHiaL4ifkJKcSeN3bytV1rZ" # desktop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPiBYp+pjF/3Q6deVfH4uMqYg6y9YbK29qZ6kNyWLxil" # laptop 
    ];
  };

  users.users.marie = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFiS+tzh0R/nN5nqSwvLerCV4nBwI51zOKahFfiiINGp"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}