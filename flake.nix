{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    marie = {
      url = "github:NyCodeGHG/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    nixos-generators,
    deploy-rs,
    agenix,
    ...
  } @ attrs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    deployPkgs = import nixpkgs {
      inherit system;
      overlays = [
        deploy-rs.overlay
        (self: super: {
          deploy-rs = {
            inherit (pkgs) deploy-rs;
            lib = super.deploy-rs.lib;
          };
        })
      ];
    };
  in {
    nixosConfigurations.july = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./server.nix
        agenix.nixosModules.default
      ];
    };
    deploy.sshOpts = ["-t"];
    deploy.nodes.july = {
      hostname = "45.129.180.33";
      sshUser = "emma";

      # required for sudo pw to work
      magicRollback = false;

      autoRollback = true;

      profiles.system = {
        user = "root";
        path = deployPkgs.deploy-rs.lib.activate.nixos self.nixosConfigurations.july;
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [agenix.packages.x86_64-linux.default];
    };
    formatter.x86_64-linux = pkgs.alejandra;
  };
}
