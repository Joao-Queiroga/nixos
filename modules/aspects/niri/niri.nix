{
  den,
  inputs,
  ...
}: {
  den.aspects.niri = {
    nixos = {
      programs.niri.enable = true;
    };
    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: {
      home.packages = with pkgs; [
        jq
      ];
      wayland.windowManager.niri = let
        colors = config.lib.stylix.colors.withHashtag;
      in {
        enable = true;
        settings = {
          input = {
            keyboard = {
              xkb = {
                layout = "br";
              };
              numlock = {};
            };
            touchpad = {tap = {};};
            focus-follows-mouse = {
              _props = {
                max-scroll-amount = "0%";
              };
            };
          };
          cursor = with config.stylix.cursor; {
            xcursor-theme = name;
            xcursor-size = size;
          };
          prefer-no-csd = {};
          layout = {
            gaps = 16;
            struts = {
              left = 0;
              right = 0;
              top = 0;
              bottom = 0;
            };
            focus-ring = {off = {};};
            border = {
              width = 1;
              active-color = colors.base0D;
              inactive-color = colors.base03;
            };
            center-focused-column = "never";
          };
          debug.honor-xdg-activation-with-invalid-serial = {};
          _children = [
            {
              output = {
                _args = ["DP-1"];
                mode = "1920x1080";
                variable-refresh-rate._props = {on-demand = false;};
                focus-at-startup = {};
              };
            }
            {
              output = {
                _args = ["LG Electronics LG TV 0x01010101"];
                off = {};
                mode = "1920x1080";
              };
            }
            {
              layer-rule = {
                match._props = {namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";};
                background-effect = {
                  xray = false;
                };
              };
            }
            {
              layer-rule = {
                match._props = {namespace = "^noctalia-backdrop";};
                place-within-backdrop = true;
              };
            }
            {
              window-rule = {
                geometry-corner-radius = 20;
                clip-to-geometry = true;
              };
            }
            {
              window-rule = {
                _children = [{match._props = {app-id = "brave-browser";};} {match._props = {app-id = "kitty";};}];
                open-maximized = true;
              };
            }
          ];
          binds = {
            "Mod+Shift+Slash".show-hotkey-overlay = {};

            "Mod+Return" = {
              _props = {hotkey-overlay-title = "Open a Terminal: Kitty";};
              spawn = ["kitty" "-1"];
            };
            "Ctrl+Shift+Escape" = {
              _props = {hotkey-overlay-title = "Open a Terminal: Kitty";};
              spawn = ["kitty" "-1" "btop"];
            };
            "Mod+Shift+Return" = {
              _props = {hotkey-overlay-title = "Open a File Manager";};
              spawn = ["thunar"];
            };

            "Mod+R" = {
              _props = {hotkey-overlay-title = "Run an Application: Noctalia-shell";};
              spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
            };

            "Mod+P" = {
              _props = {hotkey-overlay-title = "Run an Command: bemenu";};
              spawn = ["bemenu-run" "--binding" "vim"];
            };

            "Mod+V" = {
              _props = {hotkey-overlay-title = "Clipboard History";};
              spawn = ["noctalia" "msg" "panel-toggle" "clipboard"];
            };

            "Mod+B" = {
              _props = {hotkey-overlay-title = "Open Browser";};
              spawn = ["brave"];
            };

            "Mod+M" = {
              _props = {hotkey-overlay-title = "Ligar/desligar monitor";};
              spawn = ["sh" "${./monitors.sh}"];
            };

            "XF86AudioPlay".spawn = [(lib.getExe pkgs.playerctl) "play"];
            "XF86AudioNext".spawn = [(lib.getExe pkgs.playerctl) "next"];
            "XF86AudioPrev".spawn = [(lib.getExe pkgs.playerctl) "previous"];
            "XF86AudioStop".spawn = [(lib.getExe pkgs.playerctl) "stop"];

            "XF86AudioRaiseVolume".spawn-sh = ["wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"];
            "XF86AudioLowerVolume".spawn-sh = ["wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"];
            "XF86AudioMute".spawn-sh = ["wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"];
            "XF86AudioMicMute".spawn-sh = ["wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"];

            "XF86MonBrightnessUp".spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
            "XF86MonBrightnessDown".spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];

            "Ctrl+Space".spawn = ["noctalia" "msg" "notification-clear-active"];

            "Mod+O" = {
              _props = {repeat = false;};
              toggle-overview = {};
            };

            "Mod+Shift+C" = {
              _props = {repeat = false;};
              close-window = {};
            };

            "Mod+Left".focus-column-left = {};
            "Mod+Down".focus-window-down = {};
            "Mod+Up".focus-window-up = {};
            "Mod+Right".focus-column-right = {};
            "Mod+H".focus-column-left = {};
            "Mod+J".focus-workspace-down = {};
            "Mod+K".focus-workspace-up = {};
            "Mod+L".focus-column-right = {};

            "Mod+Ctrl+Left".move-column-left = {};
            "Mod+Ctrl+Down".move-window-down = {};
            "Mod+Ctrl+Up".move-window-up = {};
            "Mod+Ctrl+Right".move-column-right = {};
            "Mod+Ctrl+J".move-workspace-down = {};
            "Mod+Ctrl+K".move-workspace-up = {};

            "Mod+Home".focus-column-first = {};
            "Mod+End".focus-column-last = {};
            "Mod+Ctrl+Home".move-column-to-first = {};
            "Mod+Ctrl+End".move-column-to-last = {};

            "Mod+Shift+Left".focus-monitor-left = {};
            "Mod+Shift+Down".focus-monitor-down = {};
            "Mod+Shift+Up".focus-monitor-up = {};
            "Mod+Shift+Right".focus-monitor-right = {};
            "Mod+Ctrl+H".focus-monitor-left = {};
            "Mod+Ctrl+L".focus-monitor-right = {};
            "Mod+Shift+H".move-column-left = {};
            "Mod+Shift+J".move-column-to-workspace-down = {};
            "Mod+Shift+K".move-column-to-workspace-up = {};
            "Mod+Shift+L".move-column-right = {};

            "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = {};
            "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = {};
            "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = {};
            "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = {};
            "Mod+Shift+Ctrl+H".move-column-to-monitor-left = {};
            "Mod+Shift+Ctrl+J".move-column-to-monitor-down = {};
            "Mod+Shift+Ctrl+K".move-column-to-monitor-up = {};
            "Mod+Shift+Ctrl+L".move-column-to-monitor-right = {};

            "Mod+Page_Down".focus-workspace-down = {};
            "Mod+Page_Up".focus-workspace-up = {};
            "Mod+U".focus-workspace-down = {};
            "Mod+I".focus-workspace-up = {};
            "Mod+Ctrl+Page_Down".move-column-to-workspace-down = {};
            "Mod+Ctrl+Page_Up".move-column-to-workspace-up = {};
            "Mod+Ctrl+U".move-column-to-workspace-down = {};
            "Mod+Ctrl+I".move-column-to-workspace-up = {};

            "Mod+Shift+Page_Down".move-workspace-down = {};
            "Mod+Shift+Page_Up".move-workspace-up = {};
            "Mod+Shift+U".move-workspace-down = {};
            "Mod+Shift+I".move-workspace-up = {};

            "Mod+WheelScrollDown" = {
              _props = {cooldown-ms = 150;};
              focus-workspace-down = {};
            };

            "Mod+WheelScrollUp" = {
              _props = {cooldown-ms = 150;};
              focus-workspace-up = {};
            };

            "Mod+Ctrl+WheelScrollDown" = {
              _props = {cooldown-ms = 150;};
              move-column-to-workspace-down = {};
            };

            "Mod+Ctrl+WheelScrollUp" = {
              _props = {cooldown-ms = 150;};
              move-column-to-workspace-up = {};
            };

            "Mod+WheelScrollRight".focus-column-right = {};
            "Mod+WheelScrollLeft".focus-column-left = {};
            "Mod+Ctrl+WheelScrollRight".move-column-right = {};
            "Mod+Ctrl+WheelScrollLeft".move-column-left = {};

            "Mod+Shift+WheelScrollDown".focus-column-right = {};
            "Mod+Shift+WheelScrollUp".focus-column-left = {};
            "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = {};
            "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = {};

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;

            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;
            "Mod+Shift+5".move-column-to-workspace = 5;
            "Mod+Shift+6".move-column-to-workspace = 6;
            "Mod+Shift+7".move-column-to-workspace = 7;
            "Mod+Shift+8".move-column-to-workspace = 8;
            "Mod+Shift+9".move-column-to-workspace = 9;

            "Mod+BracketLeft".consume-or-expel-window-left = {};
            "Mod+BracketRight".consume-or-expel-window-right = {};

            "Mod+Comma".consume-window-into-column = {};
            "Mod+Period".expel-window-from-column = {};

            "Mod+S".switch-preset-column-width = {};
            "Mod+Shift+S".switch-preset-window-height = {};
            "Mod+Ctrl+S".reset-window-height = {};
            "Mod+F".maximize-column = {};
            "Mod+Shift+F".fullscreen-window = {};

            "Mod+Ctrl+F".expand-column-to-available-width = {};

            "Mod+C".center-column = {};
            "Mod+Ctrl+C".center-visible-columns = {};

            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";

            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            "Mod+T".toggle-window-floating = {};
            "Mod+Shift+T".switch-focus-between-floating-and-tiling = {};

            "Print".screenshot = {};
            "Ctrl+Print".screenshot-screen = {};
            "Alt+Print".screenshot-window = {};

            "Mod+Escape" = {
              _props = {allow-inhibiting = false;};
              toggle-keyboard-shortcuts-inhibit = {};
            };

            "Mod+Shift+Q".quit._props.skip-confirmation = true;
            "Ctrl+Alt+Delete".quit = {};

            "Mod+Shift+P".power-off-monitors = {};
          };
        };
      };
    };
  };
}
