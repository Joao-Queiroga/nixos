{
  den,
  inputs,
  ...
}: {
  den.aspects.hyprland-user.homeManager = {
    pkgs,
    lib,
    config,
    ...
  }: let
    myPkgs = with pkgs; [
      inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.hyprshutdown
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
}
