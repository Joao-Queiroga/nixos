{inputs, ...}: {
  flake.nixosModules.displayManager = {
    pkgs,
    config,
    lib,
    ...
  }: {
    environment.systemPackages = [config.stylix.cursor.package];
    services.displayManager = {
      generic.environment = {
        XKB_DEFAULT_LAYOUT = "br";
        XCURSOR_PATH = "${config.stylix.cursor.package}/share/icons:${config.stylix.cursor.package}/share/cursors";
        XCURSOR_THEME = config.stylix.cursor.name;
        XCURSOR_SIZE = toString config.stylix.cursor.size;
      };
      sddm = {
        enable = true;
        autoNumlock = true;
        theme = "${
          (pkgs.sddm-astronaut.override {embeddedTheme = "black_hole";})
        }/share/sddm/themes/sddm-astronaut-theme/";
        wayland.enable = true;
        extraPackages = with pkgs.kdePackages; [
          qtmultimedia
          qtsvg
          qtvirtualkeyboard
        ];
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
              shell = {
                cursor-theme = config.stylix.cursor.name;
                cursor-size = config.stylix.cursor.size;
              };
            };
          in "${lib.getExe pkgs.weston} --shell=kiosk -c ${westonIni}";
        };
      };
    };
  };
}
