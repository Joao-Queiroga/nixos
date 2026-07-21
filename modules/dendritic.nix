{inputs, ...}: {
  imports = [
    (inputs.flake-file.flakeModules.dendritic or {})
    (inputs.den.flakeModules.dendritic or {})
    inputs.wrapper-modules.flakeModules.wrappers
  ];

  flake-file.inputs = {
    den.url = "github:denful/den";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-file.url = "github:vic/flake-file";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrapper-modules.url = "github:birdeehub/nix-wrapper-modules";
    wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";
  };
}
