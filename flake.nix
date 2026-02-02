{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-neovim.url = "github:/Joao-Queiroga/nvim";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs";
    wrappers.url = "github:birdeehub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal-niri = {
      url = "github:sameoldlab/astal?ref=feat/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.astal.follows = "astal";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
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
    nixpkgs-stable,
    stylix,
    home-manager,
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
          ./modules/hosts/common-configuration.nix
          ./modules/hosts/${hostname}/configuration.nix
        ];
        specialArgs = {inherit inputs pkgs-stable;};
      };
  in {
    nixosConfigurations = {
      tux = createConfig "tux";
      tuxnote = createConfig "tuxnote";
    };
    homeConfigurations."joaoqueiroga" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        inputs.stylix.homeModules.stylix
        ./modules/home/home.nix
      ];

      extraSpecialArgs = {
        inherit inputs pkgs-stable;
      };
    };
  };
}
