{
  den,
  inputs,
  ...
}: {
  den.aspects.noctalia = {
    homeManager = {
      pkgs,
      config,
      lib,
      ...
    }: let
      wallpaperDir = "${config.home.homeDirectory}/Imagens/Wallpappers";
    in {
      imports = [inputs.noctalia.homeModules.default];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          audio = {
            enable_overdrive = true;
            enable_sounds = true;
          };
          keybinds = {
            down = ["Tab"];
            tab_next = ["Ctrl+Tab"];
            tab_previous = ["Ctrl+Shift+ISO_Left_Tab"];
            up = ["Shift+ISO_Left_Tab"];
          };
          backdrop.enabled = true;

          bar.default = {
            background_opacity = 0.9;
            end = [
              "tray"
              "notifications"
              "clipboard"
              "network"
              "bluetooth"
              "volume"
              "brightness"
              "battery"
              "session"
            ];
            margin_edge = 5;
            margin_ends = 7;
            start = [
              "launcher"
              "workspaces"
              "active_window"
              "media"
            ];
          };

          brightness = {
            enable_ddcutil = true;
          };

          desktop_widgets = {
            schema_version = 2;
            widget_order = [
              "desktop-widget-0000000000000001"
              "desktop-widget-0000000000000003"
              "desktop-widget-0000000000000004"
            ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget."desktop-widget-0000000000000001" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 1712.0;
              cy = 971.0;
              output = "DP-1";
              rotation = 0.0;
              type = "clock";
              settings = {
                background = false;
              };
            };

            widget."desktop-widget-0000000000000003" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 208.0;
              cy = 774.0;
              output = "DP-1";
              rotation = 0.0;
              type = "fancy_audio_visualizer";
              settings = {
                background = false;
                visualization_mode = "bars";
              };
            };

            widget."desktop-widget-0000000000000004" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 148.0;
              cy = 268.0;
              output = "DP-1";
              rotation = 0.0;
              type = "media_player";
              settings = {
                background = true;
                layout = "vertical";
              };
            };
          };

          dock = {
            active_monitor_only = true;
            auto_hide = true;
            enabled = true;
            background_opacity = lib.mkForce 0.5;
            reserve_space = false;
            show_dots = true;
          };

          idle = {
            behavior_order = [
              "lock"
              "screen-off"
              "lock-and-suspend"
            ];

            behavior.lock = {
              action = "lock";
              enabled = true;
              timeout = 600.0;
            };

            behavior."lock-and-suspend" = {
              action = "lock_and_suspend";
              enabled = false;
              timeout = 900.0;
            };

            behavior."screen-off" = {
              action = "screen_off";
              enabled = true;
              timeout = 660.0;
            };
          };

          location = {
            auto_locate = true;
          };

          lockscreen_widgets = {
            enabled = true;
            schema_version = 2;
            widget_order = [
              "lockscreen-login-box@HDMI-A-1"
              "lockscreen-login-box@DP-1"
            ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget."lockscreen-login-box@DP-1" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 960.0;
              cy = 957.0;
              output = "DP-1";
              rotation = 0.0;
              type = "login_box";
            };

            widget."lockscreen-login-box@HDMI-A-1" = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 960.0;
              cy = 957.0;
              output = "HDMI-A-1";
              rotation = 0.0;
              type = "login_box";
            };
          };

          nightlight = {
            enabled = true;
          };

          notification = {
            layer = "overlay";
            background_opacity = lib.mkForce 0.5;
          };

          shell = {
            launch_apps_as_systemd_services = true;
            niri_overview_type_to_launch_enabled = true;
            polkit_agent = true;
            settings_show_advanced = false;

            launcher = {
              launcher_categories = false;
            };
            panel = {
              launcher_categories = false;
            };

            screen_corners = {
              enabled = true;
            };
          };

          theme = {
            templates = {
              enable_builtin_templates = false;
              enable_community_templates = false;
            };
          };

          wallpaper = {
            directory = wallpaperDir;
            default.path = "${config.xdg.configHome}/.background";
          };

          widget.active_window = {
            title_scroll = "on_hover";
          };

          widget.brightness = {
            show_label = false;
          };

          widget.network = {
            show_label = false;
          };

          widget.tray = {
            capsule = true;
            scale = 1.4;
          };

          widget.workspaces = {
            display = "none";
          };
        };
      };
    };
  };
  flake-file.inputs = {
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
  };
}
