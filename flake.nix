{
  description = "Flake setup for NixOS laptop - eventually for other machines.";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
	config.allowUnfree = true;
      };
    
    in {
      nixosConfigurations = {
        framework = lib.nixosSystem {
	  inherit pkgs system;
	  modules = [ 
	    ./configuration.nix 
	    nixos-hardware.nixosModules.framework-12th-gen-intel
	    
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.inalone = {
	        imports = [ ./home.nix ];
	      };
	    }
	  ];
	};
      };
    };
}
