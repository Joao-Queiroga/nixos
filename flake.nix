{
  inputs = {
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    my-neovim.url = "github:/Joao-Queiroga/nvim";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    wrappers.url = "github:birdeehub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    astal-niri = {
      url = "github:sameoldlab/astal?ref=feat/niri";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.astal.follows = "astal";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    # Yazi plugins
    drag = {
      url = "github:Joao-Queiroga/drag.yazi";
      flake = false;
    };
    gvfs-yazi = {
      url = "github:boydaihungst/gvfs.yazi";
      flake = false;
    };
  };
  outputs = inputs @ {
    self,
    determinate,
    nixpkgs,
    nixpkgs-unstable,
    stylix,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    createConfig = hostname:
      nixpkgs.lib.nixosSystem {
        modules = [
          determinate.nixosModules.default
          stylix.nixosModules.stylix
          {networking.hostName = hostname;}
          ./modules/hosts/common-configuration.nix
          ./modules/hosts/${hostname}/configuration.nix
        ];
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
      };
  in {
    nixosConfigurations = {
      tux = createConfig "tux";
      tuxnote = createConfig "tuxnote";
    };
    homeConfigurations."joaoqueiroga" = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs-unstable;
      modules = [
        inputs.stylix.homeModules.stylix
        inputs.my-neovim.homeModules.default
        ./modules/home/home.nix
      ];

      extraSpecialArgs = {
        inherit inputs;
        pkgs-stable = pkgs;
      };
    };
  };
}
