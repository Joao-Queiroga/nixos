{
  description = "My flake";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprnix.url = "github:hyprwm/hyprnix";
    my-neovim.url = "github:/Joao-Queiroga/nvim";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs";
    wrapper-modules.url = "github:birdeehub/nix-wrapper-modules";
    wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
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

    qylock = {
      url = "github:Darkkal44/qylock";
      flake = false;
    };
  };
}
