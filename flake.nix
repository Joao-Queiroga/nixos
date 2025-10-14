{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nordvpn-flake = {
      url = "github:conneroisu/nordvpn-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    glfw-patch = {
      url = "https://github.com/BoyOrigin/glfw-wayland/raw/main/patches/0001-Key-Modifiers-Fix.patch";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    determinate,
    nixpkgs,
    stylix,
    chaotic,
    nordvpn-flake,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    createConfig = hostname:
      nixpkgs.lib.nixosSystem {
        modules = [
          stylix.nixosModules.stylix
          determinate.nixosModules.default
          chaotic.nixosModules.default
          nordvpn-flake.nixosModules.default
          {networking.hostName = hostname;}
          ./common-configuration.nix
          ./${hostname}/configuration.nix
        ];
        specialArgs = {inherit inputs;};
      };
  in {
    nixosConfigurations = {
      tux = createConfig "tux";
      tuxnote = createConfig "tuxnote";
    };
  };
}
