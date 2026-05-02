{inputs, ...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowInsecure = true;
      overlays = [
        (final: prev: let
          pkgs-small = import inputs.nixpkgs-small {
            inherit system;
            config.allowUnfree = true;
            config.allowInsecure = true;
          };
        in {
          niri = pkgs-small.niri;
          vimPlugins = pkgs-small.vimPlugins;
        })
      ];
    };
  };
}
