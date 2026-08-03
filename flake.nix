{
  description = "Hazem's NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";

    # Used to get newer versions of specific packages (opencode, ...).
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinning to "cachix" branch for cached pre-built binaries.
    # We do NOT use follows = "nixpkgs" here to ensure we hit the binary cache.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      noctalia,
      plasma-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.nixbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        nixpkgs.overlays = [
          (_final: prev: let
            system = prev.stdenv.hostPlatform.system;
            unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          in {
            opencode = unstable.opencode;
          })
        ];
        # Pass inputs to configuration.nix
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                inputs.plasma-manager.homeModules.plasma-manager
                inputs.noctalia.homeModules.default
              ];
              # Pass inputs to home.nix
              extraSpecialArgs = { inherit inputs; };
              users.hazem = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
