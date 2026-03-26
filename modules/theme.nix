{...}: let
  theme = {
    base00 = "#16161e";
    base01 = "#1a1b26";
    base02 = "#2f3549";
    base03 = "#444b6a";
    base04 = "#787c99";
    base05 = "#c0caf5";
    base06 = "#cbccd1";
    base07 = "#d5d6db";
    base08 = "#f7768e";
    base09 = "#faba4a";
    base0A = "#e0af68";
    base0B = "#9ece6a";
    base0C = "#7dcfff";
    base0D = "#7aa2f7";
    base0E = "#bb9af7";
    base0F = "#d18616";
  };

  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;

  themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
in {
  flake = {
    inherit theme themeNoHash;
  };
}
