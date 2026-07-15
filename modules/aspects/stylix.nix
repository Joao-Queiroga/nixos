{
  den,
  inputs,
  self,
  ...
}: {
  den.aspects.stylix = {
    nixos = {
      config,
      lib,
      pkgs,
      ...
    }: {
      imports = [inputs.stylix.nixosModules.stylix];
      config = {
        stylix = {
          enable = true;
          base16Scheme = self.theme;
          cursor = {
            name = "BreezeX-RosePine-Linux";
            package = pkgs.rose-pine-cursor;
            size = 27;
          };
          icons = {
            enable = true;
            dark = "Papirus-Dark";
            light = "Papirus-Light";
            package = pkgs.papirus-icon-theme;
          };
          fonts.monospace = {
            name = "JetBrainsMono Nerd Font";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };
          polarity = "dark";
          targets.grub.useWallpaper = false;
          targets.chromium.enable = false;
        };
      };
    };
  };
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
