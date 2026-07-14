{ den, ... }: {
  den.aspects.user-services = {
    homeManager = {
      services = {
        udiskie = {
          enable = true;
          tray = "auto";
          settings.program_options.terminal = "kitty -1";
        };
        network-manager-applet.enable = true;
        kdeconnect = {
          enable = true;
          indicator = true;
        };
        wluma = {
          enable = true;
          settings = {
            als.time.thresholds = {
              "0" = "night"; "7" = "dark"; "9" = "dim";
              "11" = "normal"; "13" = "bright"; "16" = "normal";
              "18" = "dark"; "20" = "night";
            };
            output.ddcutil = [{
              name = "DP-1";
              capturer = "wayland";
              predictor.manual = {
                thresholds.day = { "0" = 0; "100" = 10; };
                thresholds.night = { "0" = 0; "100" = 60; };
              };
            }];
            output.backlight = [{
              name = "eDP-1";
              path = "/sys/class/backlight/intel_backlight";
              capturer = "wayland";
              predictor.manual = {
                thresholds.day = { "0" = 0; "100" = 10; };
                thresholds.night = { "0" = 0; "100" = 60; };
              };
            }];
          };
        };
      };
    };
  };
}
