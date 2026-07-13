{inputs, ...}: {
  imports = [
    (inputs.flake-file.flakeModules.dendritic or {})
    (inputs.den.flakeModules.dendritic or {})
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  flake-file.inputs = {
    den.url = "github:denful/den";
    flake-file.url = "github:vic/flake-file";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprnix.url = "github:hyprwm/hyprnix";
    my-neovim.url = "github:/Joao-Queiroga/nvim";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs";
    wrapper-modules.url = "github:birdeehub/nix-wrapper-modules";
    wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";

    lsfg-vk = {
      url = "github:PancakeTAS/lsfg-vk";
      flake = false;
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    qylock = {
      url = "github:Darkkal44/qylock";
      flake = false;
    };
  };
}
