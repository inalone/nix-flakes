{
  description = "inalone nix flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    home-manager,
    nixos-hardware,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree = true;
      };
    };
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      aiko = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};

        modules = [
          ./machines/aiko/configuration.nix
          nixos-hardware.nixosModules.framework-12th-gen-intel
        ];
      };
    };

    homeConfigurations = {
      aiko = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./machines/aiko/home.nix
        ];
      };
    };
  };
}
