{inputs, ...}: {
  options = {
    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
      wrapperModules = inputs.nixpkgs.lib.mkOption {
        default = {};
      };
    };
  };

  imports = [
    inputs.home-manager.flakeModules.home-manager
    inputs.wrapper-modules.flakeModules.wrappers
  ];
  config = {
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
