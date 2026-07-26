{
  description = "NixOS from Scratch";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinning to "cachix" branch for cached pre-built binaries.
    # We do NOT use follows = "nixpkgs" here to ensure we hit the binary cache.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      noctalia,
      ...
    }@inputs:
    {
      nixosConfigurations.nixbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Pass inputs to configuration.nix
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
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
