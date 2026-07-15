{...}: let
  theme = {
    base00 = "#1a1b26";
    base01 = "#16161e";
    base02 = "#0C0E14";
    base03 = "#545c7e";
    base04 = "#737aa2";
    base05 = "#c0caf5";
    base06 = "#a9b1d6";
    base07 = "#d5d6db";
    base08 = "#f7768e";
    base09 = "#ff9e64";
    base0A = "#e0af68";
    base0B = "#9ece6a";
    base0C = "#7dcfff";
    base0D = "#7aa2f7";
    base0E = "#bb9af7";
    base0F = "#db4b4b";
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
