{ ... }:
{
  imports = [
    ./mariadb.nix
    ./mongodb.nix
    ./postgres.nix
    ./redis-railboard.nix
  ];
}