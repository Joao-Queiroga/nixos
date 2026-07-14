{ den, inputs, ... }: {
  den.aspects.display.nixos = { config, pkgs, lib, ... }: {
    services.xserver.enable = true;
    environment.systemPackages = [ config.stylix.cursor.package ];
    services.displayManager = {
      sddm = {
        enable = true; autoNumlock = true;
        theme = "${inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.qylock}/share/sddm/themes/pixel-hollowknight";
        wayland.enable = true;
        extraPackages = [ inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.qylock ];
        settings = {
          Theme = { CursorTheme = config.stylix.cursor.name; CursorSize = config.stylix.cursor.size; };
          Wayland.CompositorCommand = let
            xcfg = config.services.xserver;
            westonIni = (pkgs.formats.ini { }).generate "weston.ini" {
              libinput = { enable-tap = config.services.libinput.mouse.tapping; left-handed = config.services.libinput.mouse.leftHanded; };
              keyboard = { keymap_model = xcfg.xkb.model; keymap_layout = xcfg.xkb.layout; keymap_variant = xcfg.xkb.variant; keymap_options = xcfg.xkb.options; numlock-on = config.services.displayManager.sddm.autoNumlock; };
            };
          in "${lib.getExe pkgs.weston} --shell=kiosk -c ${westonIni}";
        };
      };
    };
  };
}
