{
  description = "My flake";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable-small";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-neovim.url = "github:/Joao-Queiroga/nvim";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs";
    wrapper-modules.url = "github:birdeehub/nix-wrapper-modules";
    wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit?ref=v0.54.1";
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
