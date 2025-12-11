{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    determinate,
    nixpkgs,
    nixpkgs-stable,
    stylix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
    createConfig = hostname:
      nixpkgs.lib.nixosSystem {
        modules = [
          stylix.nixosModules.stylix
          determinate.nixosModules.default
          {networking.hostName = hostname;}
          ./common-configuration.nix
          ./${hostname}/configuration.nix
        ];
        specialArgs = {inherit inputs pkgs-stable;};
      };
  in {
    nixosConfigurations = {
      tux = createConfig "tux";
      tuxnote = createConfig "tuxnote";
    };
  };
}
