{
  den,
  inputs,
  ...
}: {
  den.aspects.display.nixos = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.qylock.nixosModules.default];
    services.xserver.enable = true;
    environment.systemPackages = [config.stylix.cursor.package];
    programs.qylock = {
      enable = true;
      theme = "pixel-hollowknight";
      sddm.enable = true;
    };
    services.displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        settings = {
          Theme = {
            CursorTheme = config.stylix.cursor.name;
            CursorSize = config.stylix.cursor.size;
          };
          Wayland.CompositorCommand = let
            xcfg = config.services.xserver;
            westonIni = (pkgs.formats.ini {}).generate "weston.ini" {
              libinput = {
                enable-tap = config.services.libinput.mouse.tapping;
                left-handed = config.services.libinput.mouse.leftHanded;
              };
              keyboard = {
                keymap_model = xcfg.xkb.model;
                keymap_layout = xcfg.xkb.layout;
                keymap_variant = xcfg.xkb.variant;
                keymap_options = xcfg.xkb.options;
                numlock-on = config.services.displayManager.sddm.autoNumlock;
              };
            };
          in "${lib.getExe pkgs.weston} --shell=kiosk -c ${westonIni}";
        };
      };
    };
  };
  flake-file.inputs = {
    qylock.url = "github:Darkkal44/qylock";
  };
}
