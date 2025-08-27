{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };
  outputs = inputs@{ self, nixpkgs, chaotic, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      createConfig = hostname:
        nixpkgs.lib.nixosSystem {
          modules = [
            { networking.hostName = hostname; }
            ./common-configuration.nix
            ./${hostname}/configuration.nix
            chaotic.nixosModules.default
          ];
        };
    in {
      nixosConfigurations.tux = createConfig "tux";
      nixosConfigurations.tuxnote = createConfig "tuxnote";
    };
}
