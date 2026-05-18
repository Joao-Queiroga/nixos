{
  inputs,
  self,
  ...
}: {
  flake.homeModules.hyprland = {
    pkgs,
    lib,
    ...
  }: let
    noctalia = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell;
  in {
    home.packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell
      inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.hyprpwcenter
      pkgs.runapp
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.enable = true;
      systemd.enableXdgAutostart = true;
      extraConfig = let
        myPkgs = with pkgs; [
          inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.hyprshutdown
          runapp
          playerctl
          brightnessctl
        ];
        namedPkgs = {
          noctalia = noctalia;
        };

        vars = {
        };

        pkgsSet = lib.genAttrs (map (p: p.pname) myPkgs) (
          name:
            lib.findFirst (p: p.pname == name) null myPkgs
        );

        mergedPkgs = pkgsSet // namedPkgs;

        toLuaTable = set: prefix:
          "{\n"
          + lib.concatStringsSep ",\n" (
            lib.mapAttrsToList (k: v: ''${k} = "${prefix v}"'') set
          )
          + "\n}";
      in
        # lua
        ''
          package.path = package.path .. ";${./.}/?.lua"
          _G.nix = {
            pkgs = ${toLuaTable mergedPkgs lib.getExe},
            pkgpath = ${toLuaTable mergedPkgs (p: "${p}")},
            vars = ${toLuaTable vars (v: v)},
          }
          require("config")
        '';
    };
    # services.awww.enable = true;
    services.hyprpolkitagent = {
      enable = true;
    };
  };
}
