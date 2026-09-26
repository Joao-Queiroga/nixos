{
  den,
  inputs,
  ...
}:
{
  den.aspects.mango = {
    nixos = {
      imports = [
        inputs.mangowm.nixosModules.mango
      ];
      programs.mango.enable = true;
    };
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        imports = [
          inputs.mangowm.hmModules.mango
        ];
        home.packages = with pkgs; [
          grim
          slurp
          jq
          libnotify
        ];
        wayland.windowManager.mango = {
          enable = true;
          settings =
            let
              colors = config.lib.stylix.colors;
              cursor = config.stylix.cursor;
            in
            {
              numlockon = 1;
              xkb_rules_layout = "br";

              # troca de tags animada na vertical (0 = vertical, 1 = horizontal)
              tag_animation_direction = 0;
              # cooldown das binds de scroll (niri: cooldown-ms = 150)
              axis_bind_apply_timeout = 150;

              # aparência (niri: layout.gaps/border, cursor, input)
              gappih = 16;
              gappiv = 16;
              gappoh = 16;
              gappov = 16;
              borderpx = 1;
              border_radius = 20;
              focuscolor = "0x${colors.base0D}ff";
              bordercolor = "0x${colors.base03}ff";
              cursor_theme = cursor.name;
              cursor_size = cursor.size;
              # niri: focus-follows-mouse e tap-to-click (já são padrão, explícitos)
              sloppyfocus = 1;
              tap_to_click = 1;

              # layout scroller (~ niri/hyprland scrolling)
              scroller_default_proportion = 0.5;
              # SUPER+F cicla entre 0.5 e 1.0
              scroller_proportion_preset = "0.5,1.0";
              # aplica presets também com uma única janela aberta
              scroller_ignore_proportion_single = 0;

              tagrule = [
                # todas as tags usam scroller; no_hide = workspaces persistentes
                # do hyprland (visível para barras via ext-workspace)
                "id:*,layout_name:scroller,no_hide:1"
              ];

              windowrule = [
                # niri: open-maximized (mango não tem regra de abrir maximizado;
                # proporção 1.0 ≈ coluna de largura total)
                "scroller_proportion:1.0,appid:brave-browser"
                "scroller_proportion:1.0,appid:brave-origin"
                "scroller_proportion:1.0,appid:kitty"
                # hyprland: workspace rules adaptadas para tags
                "tags:2,appid:brave-browser"
                "tags:2,appid:brave-origin"
                "tags:2,appid:firefox"
                "tags:6,appid:discord"
                "tags:6,appid:WebCord"
                "tags:7,appid:teams-for-linux"
              ];

              layerrule = [
                # slurp/screenshot: sem blur/animação na camada de seleção
                "noanim:1,noblur:1,layer_name:selection"
              ];

              monitorrule = [
                # niri: DP-1 1920x1080, VRR off (refresh:999 = modo 1080p de
                # maior taxa ≈ highrr do hyprland; cai no preferred se não houver)
                "name:^DP-1$,width:1920,height:1080,refresh:999,vrr:0"
                # niri: LG TV (HDMI-A-1) desligada
                "name:^HDMI-A-1$,disable:1"
              ];

              # Keybinds convertidos do niri (modules/aspects/niri/niri.nix)
              bind = [
                # aplicativos
                "SUPER,Return,spawn,kitty -1"
                "CTRL+SHIFT,Escape,spawn,kitty -1 btop"
                "SUPER+SHIFT,Return,spawn,thunar"
                "SUPER,R,spawn,noctalia msg panel-toggle launcher"
                "SUPER,P,spawn,bemenu-run --binding vim"
                "SUPER,V,spawn,noctalia msg panel-toggle clipboard"
                "SUPER,B,spawn,brave-origin"
                "SUPER,M,spawn,sh ${./monitors.sh}"
                "CTRL,space,spawn,noctalia msg notification-clear-active"
                "SUPER,Q,reload_config"

                # janela
                "SUPER+SHIFT,C,killclient"
                "SUPER,O,toggleoverview"
                "SUPER,T,togglefloating"
                # aprox: switch-focus-between-floating-and-tiling
                "SUPER+SHIFT,T,focuslast"
                # alterna largura da coluna 0.5 <-> 1.0 (scroller_proportion_preset)
                "SUPER,F,switch_proportion_preset"
                "SUPER+SHIFT,F,togglefullscreen"
                # aprox: expand-column-to-available-width
                "SUPER+CTRL,F,togglegaps"
                # aprox: center-column (centerwin age em flutuantes)
                "SUPER,C,centerwin"
                # aprox: center-visible-columns
                "SUPER+CTRL,C,centerwin"

                # dimensionamento
                # aprox: switch-preset-column-width (presets do scroller)
                "SUPER,S,switch_proportion_preset"
                # aprox: switch-preset-window-height (mango não tem presets de altura)
                "SUPER+SHIFT,S,switch_proportion_preset"
                # aprox: reset-window-height -> reseta o fator master (0.55)
                "SUPER+CTRL,S,setmfact,1.55"
                # aprox: set-column-width +-10% -> fator master +-0.05
                "SUPER,Minus,setmfact,-0.05"
                "SUPER,equal,setmfact,0.05"
                # aprox: set-window-height +-10%
                "SUPER+SHIFT,Minus,resizewin,0,-10"
                "SUPER+SHIFT,Equal,resizewin,0,10"

                # aprox: consume/expel window into column (mango: groups)
                # code:35/51 = teclas dedicadas [ e ] (no layout br, BracketLeft
                # resolve para o mesmo keycode do 8: AltGr+8 = "[")
                "SUPER,code:35,groupjoin,left"
                "SUPER,period,groupleave"
                "SUPER,code:51,groupleave"

                # saida
                "SUPER+SHIFT,Q,quit"
                "CTRL+ALT,Delete,quit"
                # aprox: power-off-monitors
                "SUPER+SHIFT,P,spawn,sh ${./monitors.sh} all"

                # foco
                "SUPER,Left,focusdir,left"
                "SUPER,Down,focusdir,down"
                "SUPER,Up,focusdir,up"
                "SUPER,Right,focusdir,right"
                "SUPER,H,focusdir,left"
                "SUPER,L,focusdir,right"
                # aprox: focus-column-first/last (uma direcao por vez)
                "SUPER,Home,focusdir,left"
                "SUPER,End,focusdir,right"

                # tags (workspaces do niri): J/proximo, K/anterior
                "SUPER,J,viewtoright"
                "SUPER,K,viewtoleft"
                "SUPER,Page_Down,viewtoright"
                "SUPER,Page_Up,viewtoleft"
                "SUPER,U,viewtoright"
                "SUPER,I,viewtoleft"

                # mover janela para a tag vizinha
                "SUPER+CTRL,J,tagtoright"
                "SUPER+CTRL,K,tagtoleft"
                "SUPER+SHIFT,J,tagtoright"
                "SUPER+SHIFT,K,tagtoleft"
                "SUPER+CTRL,Page_Down,tagtoright"
                "SUPER+CTRL,Page_Up,tagtoleft"
                "SUPER+CTRL,U,tagtoright"
                "SUPER+CTRL,I,tagtoleft"
                "SUPER+SHIFT,Page_Down,tagtoright"
                "SUPER+SHIFT,Page_Up,tagtoleft"
                "SUPER+SHIFT,U,tagtoright"
                "SUPER+SHIFT,I,tagtoleft"

                # mover coluna
                "SUPER+CTRL,Left,exchange_client,left"
                "SUPER+CTRL,Down,exchange_client,down"
                "SUPER+CTRL,Up,exchange_client,up"
                "SUPER+CTRL,Right,exchange_client,right"
                "SUPER+SHIFT,H,exchange_client,left"
                "SUPER+SHIFT,L,exchange_client,right"
                # aprox: move-column-to-first/last
                "SUPER+CTRL,Home,exchange_client,left"
                "SUPER+CTRL,End,exchange_client,right"

                # monitores
                "SUPER+SHIFT,Left,focusmon,left"
                "SUPER+SHIFT,Down,focusmon,down"
                "SUPER+SHIFT,Up,focusmon,up"
                "SUPER+SHIFT,Right,focusmon,right"
                "SUPER+CTRL,H,focusmon,left"
                "SUPER+CTRL,L,focusmon,right"
                "SUPER+SHIFT+CTRL,Left,tagmon,left"
                "SUPER+SHIFT+CTRL,Down,tagmon,down"
                "SUPER+SHIFT+CTRL,Up,tagmon,up"
                "SUPER+SHIFT+CTRL,Right,tagmon,right"
                "SUPER+SHIFT+CTRL,H,tagmon,left"
                "SUPER+SHIFT+CTRL,J,tagmon,down"
                "SUPER+SHIFT+CTRL,K,tagmon,up"
                "SUPER+SHIFT+CTRL,L,tagmon,right"

                # screenshots (mango nao tem embutido)
                "NONE,Print,spawn,sh ${./screenshot.sh} region"
                "CTRL,Print,spawn,sh ${./screenshot.sh} full"
                "ALT,Print,spawn,sh ${./screenshot.sh} window"

                # submapa de redimensionar (antes so existia no config do sistema)
                "ALT,R,setkeymode,resize"
              ]
              ++ builtins.genList (i: "SUPER,${toString (i + 1)},view,${toString (i + 1)}") 9
              ++ builtins.genList (i: "SUPER+SHIFT,${toString (i + 1)},tag,${toString (i + 1)}") 9;

              # midia e brilho (funcionam com a tela travada)
              bindl = [
                "NONE,XF86AudioPlay,spawn,${lib.getExe pkgs.playerctl} play"
                "NONE,XF86AudioNext,spawn,${lib.getExe pkgs.playerctl} next"
                "NONE,XF86AudioPrev,spawn,${lib.getExe pkgs.playerctl} previous"
                "NONE,XF86AudioStop,spawn,${lib.getExe pkgs.playerctl} stop"

                "NONE,XF86AudioRaiseVolume,spawn_shell,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+"
                "NONE,XF86AudioLowerVolume,spawn_shell,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"
                "NONE,XF86AudioMute,spawn_shell,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                "NONE,XF86AudioMicMute,spawn_shell,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

                "NONE,XF86MonBrightnessUp,spawn,brightnessctl --class=backlight set +10%"
                "NONE,XF86MonBrightnessDown,spawn,brightnessctl --class=backlight set 10%-"
              ];

              # scroll (niri: Mod+WheelScroll*)
              axisbind = [
                "SUPER,UP,viewtoleft"
                "SUPER,DOWN,viewtoright"
                "SUPER,LEFT,focusdir,left"
                "SUPER,RIGHT,focusdir,right"
                "SUPER+CTRL,UP,tagtoleft"
                "SUPER+CTRL,DOWN,tagtoright"
                "SUPER+CTRL,LEFT,exchange_client,left"
                "SUPER+CTRL,RIGHT,exchange_client,right"
                "SUPER+SHIFT,UP,focusdir,left"
                "SUPER+SHIFT,DOWN,focusdir,right"
                "SUPER+CTRL+SHIFT,UP,exchange_client,left"
                "SUPER+CTRL+SHIFT,DOWN,exchange_client,right"
              ];

              # binds de mouse que vem no config padrao do mango
              mousebind = [
                "SUPER,btn_left,moveresize,curmove"
                "SUPER,btn_right,moveresize,curresize"
              ];

              # submapa de redimensionar (ALT+R)
              keymode = {
                resize = {
                  bind = [
                    "NONE,Left,resizewin,-10,0"
                    "NONE,Right,resizewin,10,0"
                    "NONE,Up,resizewin,0,-10"
                    "NONE,Down,resizewin,0,10"
                    "NONE,Escape,setkeymode,default"
                  ];
                };
              };
            };
        };
      };
  };
  flake-file.inputs = {
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
