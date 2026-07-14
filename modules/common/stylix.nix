{ den, inputs, ... }: let
  tokyo-night = {
    base00 = "16161e"; base01 = "1a1b26"; base02 = "2f3549";
    base03 = "444b6a"; base04 = "787c99"; base05 = "c0caf5";
    base06 = "cbccd1"; base07 = "d5d6db"; base08 = "f7768e";
    base09 = "faba4a"; base0A = "e0af68"; base0B = "9ece6a";
    base0C = "7dcfff"; base0D = "7aa2f7"; base0E = "bb9af7";
    base0F = "d18616";
  };
in {
  den.aspects.stylix.nixos = { config, lib, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];
    config = {
      stylix = {
        enable = true;
        base16Scheme = { inherit (tokyo-night) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F; };
        cursor = { name = "BreezeX-RosePine-Linux"; package = pkgs.rose-pine-cursor; size = 27; };
        icons = { enable = true; dark = "Papirus-Dark"; light = "Papirus-Light"; package = pkgs.papirus-icon-theme; };
        fonts.monospace = { name = "JetBrainsMono Nerd Font"; package = pkgs.nerd-fonts.jetbrains-mono; };
        polarity = "dark";
        targets.grub.useWallpaper = false; targets.chromium.enable = false;
      };
    };
  };
}
