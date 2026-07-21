{
  den,
  inputs,
  ...
}: {
  den.aspects.hyprland = {
    nixos = {pkgs, ...}: {
      programs.hyprland = {
        enable = true;
      };
      environment.systemPackages = [pkgs.hyprland];
    };
    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      myPkgs = with pkgs; [
        hyprshutdown
        runapp
        playerctl
        brightnessctl
      ];
      namedPkgs = {
      };
      pkgsSet = lib.genAttrs (map (p: p.pname) myPkgs) (
        name: lib.findFirst (p: p.pname == name) null myPkgs
      );
      mergedPkgs = pkgsSet // namedPkgs;
      toLuaTable = set: prefix:
        "{\n"
        + lib.concatStringsSep ",\n" (
          lib.mapAttrsToList (k: v: ''${k} = "${prefix v}"'') set
        )
        + "\n}";
    in {
      home.packages = [
        pkgs.runapp
      ];
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        package = null;
        portalPackage = null;
        systemd.enable = true;
        systemd.enableXdgAutostart = true;
        extraConfig = ''
          package.path = package.path .. ";${./.}/?.lua"
          _G.nix = {
            pkgs = ${toLuaTable mergedPkgs lib.getExe},
            pkgpath = ${toLuaTable mergedPkgs (p: "${p}")},
            vars = {},
          }
          require("config")
        '';
      };
    };
  };
}
