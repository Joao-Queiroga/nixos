{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, stylix, chaotic, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      createConfig = hostname:
        nixpkgs.lib.nixosSystem {
          modules = [
            stylix.nixosModules.stylix
            { networking.hostName = hostname; }
            ./common-configuration.nix
            ./${hostname}/configuration.nix
            chaotic.nixosModules.default
          ];
          specialArgs = { inherit inputs; };
        };
    in {
      nixosConfigurations = {
        tux = createConfig "tux";
        tuxnote = createConfig "tuxnote";
      };
    };
}
