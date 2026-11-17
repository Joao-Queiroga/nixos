{
  den,
  inputs,
  ...
}:
{
  den.aspects.umbriel = {
    # Só por compatibilidade: o umbriel lê as cores (base0D/base03) e o cursor
    # do stylix. Garante que o stylix esteja presente quando este aspect for usado.
    includes = [ den.aspects.stylix ];

    nixos = { lib, ... }: {
      imports = [ inputs.umbriel.nixosModules.default ];
      programs.umbriel.enable = true;
      services.displayManager.defaultSession = "umbriel";
      nix.settings = {
        extra-substituters = [ "https://umbriel.cachix.org" ];
        extra-trusted-public-keys = [
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
        ];
      };
    };

    homeManager =
      {
        pkgs,
        config,
        ...
      }:
      {
        imports = [ inputs.umbriel.homeModules.default ];

        home.packages = with pkgs; [
          jq
        ];

        programs.umbriel = {
          enable = true;
          settings =
            let
              colors = config.lib.stylix.colors.withHashtag;
            in
            {
              # ==============================================================================
              # Input
              input = {
                keyboard = {
                  layout = "br";
                  numlock_toggle = true;
                };
                touchpad.tap = true;
                # niri: focus-follows-mouse com max-scroll-amount "0%"
                focus = {
                  follows_mouse = "sloppy";
                  follows_mouse_max_scroll = 0.0;
                };
                # niri: cursor.xcursor-theme/-size
                cursor = {
                  theme = config.stylix.cursor.name;
                  size = config.stylix.cursor.size;
                };
              };

              # ==============================================================================
              # Layout
              layout = {
                mode = "scrolling";
                # niri: layout.gaps = 16
                gap = 16;
                struts = {
                  left = 0;
                  right = 0;
                  top = 0;
                  bottom = 0;
                };
                scrolling = {
                  # niri: center-focused-column = "never"
                  center_focused = "never";
                  # janela sozinha encosta na borda esquerda em vez de centralizar
                  center_underfull_strip = false;
                  default_extent_fraction = 0.5;
                };
              };

              # ==============================================================================
              # Appearance
              appearance = {
                # niri: prefer-no-csd
                prefer_no_csd = true;
                # niri: layout.border width 1
                border_width = 1;
                # niri: window-rule geometry-corner-radius 20 + clip-to-geometry
                corner_radius = 20;
                blur.radius = 3;
              };

              # niri: layout.border active-color/inactive-color
              colors.border = {
                focused = colors.base0D;
                unfocused = colors.base03;
              };

              # ==============================================================================
              # Outputs
              output = {
                # niri: DP-1 1920x1080, VRR (on-demand=false => sempre), focus-at-startup
                "DP-1" = {
                  mode = "1920x1080";
                  vrr = "always";
                  focus_at_startup = true;
                };
                # niri: LG TV desligada
                "LG Electronics LG TV 0x01010101" = {
                  enabled = false;
                  # HDR sempre ligado quando o output é usado ("auto" liga só em
                  # fullscreen com metadados HDR)
                  hdr = "on";
                };
              };

              # ==============================================================================
              # Keybinds
              keybinds = {
                # --- Aplicativos e sessão ------------------------------------------------
                # niri: show-hotkey-overlay
                "Mod+Shift+Slash" = {
                  action = "cheatsheet-toggle";
                  repeat = false;
                };
                "Mod+Return" = {
                  action = "spawn kitty -1";
                  repeat = false;
                };
                "Ctrl+Shift+Escape" = {
                  action = "spawn kitty -1 btop";
                  repeat = false;
                };
                "Mod+Shift+Return" = {
                  action = "spawn thunar";
                  repeat = false;
                };
                "Mod+R" = {
                  action = "spawn noctalia msg panel-toggle launcher";
                  repeat = false;
                };
                "Mod+P" = {
                  action = "spawn bemenu-run --binding vim";
                  repeat = false;
                };
                "Mod+V" = {
                  action = "spawn noctalia msg panel-toggle clipboard";
                  repeat = false;
                };
                "Mod+B" = {
                  action = "spawn brave-origin";
                  repeat = false;
                };
                "Mod+M" = {
                  action = "spawn sh ${./monitors.sh}";
                  repeat = false;
                };
                "Ctrl+Space" = {
                  action = "spawn noctalia msg notification-clear-active";
                  repeat = false;
                };

                # --- Mídia, volume e brilho via noctalia (OSD + seguro com a tela travada) --
                "XF86AudioPlay" = {
                  action = "spawn noctalia msg media toggle";
                  allow_when_locked = true;
                  repeat = false;
                };
                "XF86AudioNext" = {
                  action = "spawn noctalia msg media next";
                  allow_when_locked = true;
                };
                "XF86AudioPrev" = {
                  action = "spawn noctalia msg media previous";
                  allow_when_locked = true;
                };
                "XF86AudioStop" = {
                  action = "spawn noctalia msg media stop";
                  allow_when_locked = true;
                  repeat = false;
                };
                "XF86AudioRaiseVolume" = {
                  action = "spawn noctalia msg volume-up";
                  allow_when_locked = true;
                };
                "XF86AudioLowerVolume" = {
                  action = "spawn noctalia msg volume-down";
                  allow_when_locked = true;
                };
                "XF86AudioMute" = {
                  action = "spawn noctalia msg volume-mute";
                  allow_when_locked = true;
                  repeat = false;
                };
                "XF86AudioMicMute" = {
                  action = "spawn noctalia msg mic-mute";
                  allow_when_locked = true;
                  repeat = false;
                };
                "XF86MonBrightnessUp" = {
                  action = "spawn noctalia msg brightness-up";
                  allow_when_locked = true;
                };
                "XF86MonBrightnessDown" = {
                  action = "spawn noctalia msg brightness-down";
                  allow_when_locked = true;
                };

                # --- Screenshots (via noctalia) -------------------------------------------
                "Print" = {
                  action = "spawn noctalia msg screenshot-fullscreen";
                  repeat = false;
                };
                "Ctrl+Print" = {
                  action = "spawn noctalia msg screenshot-region";
                  repeat = false;
                };
                "Alt+Print" = {
                  action = "spawn noctalia msg screenshot-window";
                  repeat = false;
                };

                # --- Screenshots (via noctalia) -------------------------------------------
                "Alt+Tab" = {
                  action = "spawn noctalia msg window-switcher";
                  repeat = false;
                };

                # --- Foco e movimento ------------------------------------------------------
                "Mod+Left" = "window-focus-left";
                "Mod+Down" = "window-focus-down";
                "Mod+Up" = "window-focus-up";
                "Mod+Right" = "window-focus-right";
                "Mod+H" = "window-focus-left";
                # niri: focus-workspace-down/up
                "Mod+J" = "workspace-next";
                "Mod+K" = "workspace-previous";
                "Mod+L" = "window-focus-right";

                "Mod+Ctrl+Left" = "column-move-left";
                "Mod+Ctrl+Down" = "window-move-down";
                "Mod+Ctrl+Up" = "window-move-up";
                "Mod+Ctrl+Right" = "column-move-right";
                # niri: move-workspace-down/up (reordena a workspace)
                "Mod+Ctrl+J" = "workspace-move-down";
                "Mod+Ctrl+K" = "workspace-move-up";

                "Mod+Home" = "column-focus-first";
                "Mod+End" = "column-focus-last";
                "Mod+Ctrl+Home" = "column-move-to-first";
                "Mod+Ctrl+End" = "column-move-to-last";

                # --- Monitores -------------------------------------------------------------
                "Mod+Shift+Left" = "output-focus-left";
                "Mod+Shift+Down" = "output-focus-down";
                "Mod+Shift+Up" = "output-focus-up";
                "Mod+Shift+Right" = "output-focus-right";
                "Mod+Ctrl+H" = "output-focus-left";
                "Mod+Ctrl+L" = "output-focus-right";

                "Mod+Shift+H" = "column-move-left";
                # niri: move-column-to-workspace-down/up
                "Mod+Shift+J" = "column-move-to-workspace-next";
                "Mod+Shift+K" = "column-move-to-workspace-previous";
                "Mod+Shift+L" = "column-move-right";

                "Mod+Shift+Ctrl+Left" = "column-move-to-output-left";
                "Mod+Shift+Ctrl+Down" = "column-move-to-output-down";
                "Mod+Shift+Ctrl+Up" = "column-move-to-output-up";
                "Mod+Shift+Ctrl+Right" = "column-move-to-output-right";
                "Mod+Shift+Ctrl+H" = "column-move-to-output-left";
                "Mod+Shift+Ctrl+J" = "column-move-to-output-down";
                "Mod+Shift+Ctrl+K" = "column-move-to-output-up";
                "Mod+Shift+Ctrl+L" = "column-move-to-output-right";

                # --- Workspaces ------------------------------------------------------------
                "Mod+Page_Down" = "workspace-next";
                "Mod+Page_Up" = "workspace-previous";
                "Mod+U" = "workspace-next";
                "Mod+I" = "workspace-previous";
                "Mod+Ctrl+Page_Down" = "column-move-to-workspace-next";
                "Mod+Ctrl+Page_Up" = "column-move-to-workspace-previous";
                "Mod+Ctrl+U" = "column-move-to-workspace-next";
                "Mod+Ctrl+I" = "column-move-to-workspace-previous";
                # niri: move-workspace-down/up (reordena a workspace)
                "Mod+Shift+Page_Down" = "workspace-move-down";
                "Mod+Shift+Page_Up" = "workspace-move-up";
                "Mod+Shift+U" = "workspace-move-down";
                "Mod+Shift+I" = "workspace-move-up";

                "Mod+1" = "workspace-switch 1";
                "Mod+2" = "workspace-switch 2";
                "Mod+3" = "workspace-switch 3";
                "Mod+4" = "workspace-switch 4";
                "Mod+5" = "workspace-switch 5";
                "Mod+6" = "workspace-switch 6";
                "Mod+7" = "workspace-switch 7";
                "Mod+8" = "workspace-switch 8";
                "Mod+9" = "workspace-switch 9";
                "Mod+Shift+1" = "column-move-to-workspace 1";
                "Mod+Shift+2" = "column-move-to-workspace 2";
                "Mod+Shift+3" = "column-move-to-workspace 3";
                "Mod+Shift+4" = "column-move-to-workspace 4";
                "Mod+Shift+5" = "column-move-to-workspace 5";
                "Mod+Shift+6" = "column-move-to-workspace 6";
                "Mod+Shift+7" = "column-move-to-workspace 7";
                "Mod+Shift+8" = "column-move-to-workspace 8";
                "Mod+Shift+9" = "column-move-to-workspace 9";

                # --- Scroll (niri: Mod+WheelScroll* -> umbriel: Mod+Wheel*) ------------------
                "Mod+WheelDown" = {
                  action = "workspace-next";
                  cooldown_ms = 150;
                };
                "Mod+WheelUp" = {
                  action = "workspace-previous";
                  cooldown_ms = 150;
                };
                "Mod+Ctrl+WheelDown" = {
                  action = "column-move-to-workspace-next";
                  cooldown_ms = 150;
                };
                "Mod+Ctrl+WheelUp" = {
                  action = "column-move-to-workspace-previous";
                  cooldown_ms = 150;
                };
                "Mod+WheelRight" = "window-focus-right";
                "Mod+WheelLeft" = "window-focus-left";
                "Mod+Ctrl+WheelRight" = "column-move-right";
                "Mod+Ctrl+WheelLeft" = "column-move-left";
                "Mod+Shift+WheelDown" = "window-focus-right";
                "Mod+Shift+WheelUp" = "window-focus-left";
                "Mod+Ctrl+Shift+WheelDown" = "column-move-right";
                "Mod+Ctrl+Shift+WheelUp" = "column-move-left";

                # --- Consumir/expelir janelas ----------------------------------------------
                # niri: consume-or-expel-window-left/right
                "Mod+BracketLeft" = "window-consume-or-expel-left";
                "Mod+BracketRight" = "window-consume-or-expel-right";
                # niri: consume-window-into-column (esquerda)
                "Mod+Comma" = "window-consume-left";
                # niri: expel-window-from-column (aprox.: consume à direita)
                "Mod+Period" = "window-consume-right";

                # --- Estado e layout ---------------------------------------------------------
                "Mod+T" = {
                  action = "window-toggle-floating";
                  repeat = false;
                };
                "Mod+Shift+T" = {
                  action = "window-focus-switch-floating";
                  repeat = false;
                };
                # niri: maximize-column
                "Mod+F" = "window-toggle-maximize";
                # niri: fullscreen-window
                "Mod+Shift+F" = "window-toggle-fullscreen";
                # niri: expand-column-to-available-width (aprox.: largura 100%)
                "Mod+Ctrl+F" = "window-set-primary-extent 1.0";
                "Mod+O" = {
                  action = "overview-toggle";
                  repeat = false;
                };
                # niri: center-column / center-visible-columns (aprox.: umbriel só tem column-center)
                "Mod+C" = "column-center";
                "Mod+Ctrl+C" = "column-center";

                # --- Dimensionamento -----------------------------------------------------------
                # niri: switch-preset-column-width (cicla 1/3, 1/2, 2/3)
                "Mod+S" = "window-cycle-primary-extent";
                # niri: switch-preset-window-height
                "Mod+Shift+S" = "window-cycle-secondary-extent";
                # niri: reset-window-height (aprox.: fixa em 50%)
                "Mod+Ctrl+S" = "window-set-secondary-extent 0.5";
                # niri: set-column-width +/-10%
                "Mod+Minus" = "window-modify-primary-extent -0.1";
                "Mod+Equal" = "window-modify-primary-extent +0.1";
                # niri: set-window-height +/-10%
                "Mod+Shift+Minus" = "window-modify-secondary-extent -0.1";
                "Mod+Shift+Equal" = "window-modify-secondary-extent +0.1";

                # --- Sair / inibir ---------------------------------------------------------------
                "Mod+Shift+C" = {
                  action = "window-close";
                  repeat = false;
                };
                # niri: toggle-keyboard-shortcuts-inhibit
                "Mod+Escape" = {
                  action = "shortcuts-inhibit-toggle";
                  allow_when_inhibited = true;
                  repeat = false;
                };
                "Mod+Shift+Q" = {
                  action = "session-quit skip-confirmation";
                  repeat = false;
                };
                "Ctrl+Alt+Delete" = {
                  action = "session-quit";
                  repeat = false;
                };
                # niri: power-off-monitors (dpms-off sem argumento desliga todos)
                "Mod+Shift+P" = "dpms-off";
              };

              # ==============================================================================
              # Window rules
              # niri: open-maximized para brave/kitty
              window_rule = [
                {
                  match.app_id = [
                    "^brave-browser$"
                    "^brave-origin$"
                    "^kitty$"
                  ];
                  default_maximize = true;
                }
              ];

              # ==============================================================================
              # Layer rules (integração com o noctalia, do config padrão do umbriel)
              layer_rule = [
                {
                  match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
                  blur = true;
                  blur_ignore_alpha = 0.5;
                  blur_popups = true;
                }
                {
                  match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)$";
                  blur_optimized = false;
                }
              ];

              # ==============================================================================
              # Hot corners (overview no canto superior esquerdo)
              hot_corners.top_left = {
                enabled = true;
                delay_ms = 500;
                action = "overview-open";
              };
            };
        };
      };
  };
  flake-file = {
    nixConfig = {
      extra-substituters = [ "https://umbriel.cachix.org" ];
      extra-trusted-public-keys = [
        "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      ];
    };
    inputs.umbriel.url = "github:noctalia-dev/umbriel/cachix";
  };
}
