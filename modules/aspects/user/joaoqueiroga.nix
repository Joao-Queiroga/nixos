{ den, inputs, ... }: {
  den.aspects.joaoqueiroga = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")

      den.aspects.shell-fish
      den.aspects.shell-aliases
      den.aspects.starship
      den.aspects.atuin
      den.aspects.tmux
      den.aspects.cli-tools
      den.aspects.kitty
      den.aspects.dircolors
      den.aspects.env-vars
      den.aspects.user-services
      den.aspects.firefox-profile
      den.aspects.hyprland-user
      den.aspects.user-apps
      den.aspects.gtk-qt
    ];

    homeManager = { config, pkgs, ... }: {
      home.username = "joaoqueiroga";
      home.homeDirectory = "/home/joaoqueiroga";

      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };

      programs = {
        helix = {
          enable = true;
          package = pkgs.evil-helix;
        };
        zathura = {
          enable = true;
          options = {
            adjust-open = "width";
            selection-clipboard = "clipboard";
            window-title-basename = true;
            recolor = true;
          };
        };
        imv.enable = true;
        mpv.enable = true;
        nh = {
          enable = true;
          flake = "${config.home.homeDirectory}/Projects/nixos";
        };
        lazygit = {
          enable = true;
          settings = {
            gui.nerdFontsVersion = 3;
            os.editPreset = "nvim";
            promptToReturnFromSubprocess = false;
          };
        };
        btop = {
          enable = true;
          settings = {
            update_ms = 100;
            vim_keys = true;
            proc_tree = true;
            proc_gradient = false;
            proc_sorting = "pid";
            proc_mem_bytes = true;
            proc_filter_kernel = true;
            cpu_invert_lower = true;
            cpu_single_graph = true;
            mem_graphs = false;
          };
        };
        home-manager.enable = true;
      };
    };
  };

  # --- shell-fish ----------------------------------------------------
  den.aspects.shell-fish.homeManager = { config, pkgs, ... }: {
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting.body = "${pkgs.pfetch-rs}/bin/pfetch";
        starship_transient_prompt_func.body = "starship module character";
      };
      binds = {
        up = {
          command = "_atuin_bind_up";
          mode = "default";
        };
        "up-insert" = {
          name = "up";
          command = "_atuin_bind_up";
          mode = "insert";
        };
        "ctrl-k" = {
          command = "_atuin_bind_up";
          mode = "default";
        };
        "ctrl-k-insert" = {
          name = "ctrl-k";
          command = "_atuin_bind_up";
          mode = "insert";
        };
        enter = {
          command = [ "expand-abbr" "execute" ];
          mode = "default";
        };
        "enter-insert" = {
          name = "enter";
          command = [ "expand-abbr" "execute" ];
          mode = "insert";
        };
      };
      interactiveShellInit = ''
        set -U fish_color_command cyan
        fish_vi_key_bindings
      '';
      plugins = with pkgs.fishPlugins; [
        { name = "fishbang"; src = fishbang.src; }
        { name = "autopair"; src = autopair.src; }
        { name = "async-prompt"; src = async-prompt.src; }
      ];
    };
    programs.zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      historySubstringSearch.enable = true;
      initContent = "${pkgs.pfetch-rs}/bin/pfetch";
      profileExtra = ". ~/.config/shell/profile";
      plugins = [
        { name = "fast-syntax-highlighting"; src = pkgs.zsh-fast-syntax-highlighting; file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"; }
        { name = "zsh-autopair"; src = pkgs.zsh-autopair; file = "share/zsh/zsh-autopair/autopair.zsh"; }
        { name = "zsh-vi-mode"; src = pkgs.zsh-vi-mode; file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"; }
      ];
    };
    programs.nushell.enable = true;
  };

  # --- shell-aliases -------------------------------------------------
  den.aspects.shell-aliases.homeManager = { pkgs, ... }: {
    home.shellAliases = {
      nvimconf = "nvim ~/.config/nvim/init.lua";
      cat = "bat";
      tree = "eza --tree";
      cd = "z";
      grep = "rg";
      du = "${pkgs.dust}/bin/dust";
    };
  };

  # --- cli-tools -----------------------------------------------------
  den.aspects.cli-tools.homeManager = { pkgs, ... }: {
    programs = {
      zoxide.enable = true;
      bat.enable = true;
      ripgrep = {
        enable = true;
        arguments = [ "--hidden" "--smart-case" ];
      };
      carapace.enable = true;
      fzf = {
        enable = true;
        historyWidget.command = "";
      };
      eza = {
        enable = true;
        icons = "auto";
      };
      nix-your-shell.enable = true;
    };
  };

  # --- starship ------------------------------------------------------
  den.aspects.starship.homeManager.programs.starship = {
    enable = true;
    enableTransience = true;
    enableInteractive = false;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
        vicmd_symbol = "[](bold green)";
      };
    };
  };

  # --- atuin ---------------------------------------------------------
  den.aspects.atuin.homeManager.programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      dialect = "uk";
      enter_accept = true;
      keymap_mode = "vim-normal";
      keymap_cursor = {
        emacs = "blink-block";
        vim_insert = "steady-bar";
        vim_normal = "steady-block";
      };
    };
  };

  # --- tmux ----------------------------------------------------------
  den.aspects.tmux.homeManager = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      escapeTime = 0;
      keyMode = "vi";
      extraConfig = ''
        set -gq allow-passthrough on
        bind -n M-H previous-window
        bind -n M-L next-window
        bind C-l send-keys 'C-l'
      '';
      plugins = with pkgs.tmuxPlugins; [
        yank
        vim-tmux-navigator
        sensible
        { plugin = tokyo-night-tmux; extraConfig = "set -g @tokyo-night-tmux_window_id_style none"; }
      ];
    };
  };

  # --- terminals (kitty) ---------------------------------------------
  den.aspects.kitty.homeManager.programs.kitty = {
    enable = true;
    settings = {
      cursor = "none";
      enable_audio_bell = false;
      tab_bar_style = "slant";
      confirm_os_window_close = 0;
    };
    extraConfig = "cursor none";
  };

  # --- dircolors -----------------------------------------------------
  den.aspects.dircolors.homeManager.programs.dircolors = {
    enable = true;
    settings = {
      ln = "01;36"; or = "31;01"; tw = "34"; ow = "34";
      st = "01;34"; di = "01;34"; pi = "33"; so = "01;35";
      bd = "33;01"; cd = "33;01"; su = "01;32"; sg = "01;32";
      ex = "01;32"; fi = "00";
      "*.go" = "38;2;121;212;253"; "*.php" = "38;5;147";
      "*.js" = "38;5;220"; "*.c" = "38;5;33"; "*.h" = "38;5;97";
      "*.cpp" = "38;5;33"; "*.hpp" = "38;5;97"; "*.html" = "38;5;202";
      "*.java" = "38;5;124"; "*.lua" = "38;5;75"; "*.css" = "38;5;33";
      "*.scss" = "38;5;198"; "*.json" = "38;5;148";
      "*.py" = "38;2;255;212;59"; "*.xml" = "38;2;145;167;141";
      "*.el" = "38;5;140"; "*.sql" = "38;5;202";
      "*.vim" = "38;5;34"; "*.vifm" = "38;5;34";
      "vifmrc*" = "38;5;34"; "vimrc*" = "38;5;34"; "*.vimrc" = "38;5;34";
      "*Makefil" = "01;38;5;130"; "*LICENSE" = "38;5;226";
      "*README*" = "38;5;160"; "*.md" = "0;31"; "*.org" = "38;5;42";
      "*.log" = "0;37"; "*.txt" = "0;37"; "*.pdf" = "38;5;160";
    };
  };

  # --- env-vars ------------------------------------------------------
  den.aspects.env-vars.homeManager = { config, ... }: {
    home.sessionPath = [
      "${config.home.sessionVariables.CARGO_HOME}/bin"
      "${config.home.sessionVariables.GOPATH}/bin"
      "${config.xdg.binHome}"
    ];

    xdg.enable = true;

    home.sessionVariables = {
      EDITOR = "nvim";
      PF_INFO = "ascii title os host kernel uptime pkgs wm memory palette";
      MESA_SHADER_CACHE_DIR = "${config.home.homeDirectory}/.cache/mesa_shader_cache";
      MESA_SHADER_CACHE_MAX_SIZE = "12G";
      RADV_PERFTEST = "aco";
      NIXOS_OZONE_WL = "1";
      XINITRC = "${config.xdg.configHome}/x11/xinitrc";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
      GOPATH = "${config.xdg.dataHome}/go";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      WGETRC = "${config.xdg.configHome}/wget/wgetrc";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      ANDROID_SDK_HOME = "${config.xdg.configHome}/android";
      ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
      BUN_INSTALL = "${config.xdg.dataHome}/bun";
      NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      WINEPREFIX = "${config.xdg.dataHome}/wine";
      CARAPACE_HIDDEN = 1;
      CARAPACE_LENIENT = 1;
      CARAPACE_MATCH = 1;
      W3M_DIR = "${config.xdg.configHome}/w3m";
      MANPAGER = "nvim +Man!";
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "kitty.desktop" ];
    };

    xdg.configFile."w3m/config".text = "inline_img_protocol 4";
  };

  # --- user-services -------------------------------------------------
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

  # --- firefox-profile -----------------------------------------------
  den.aspects.firefox-profile.homeManager = { config, lib, ... }: {
    programs.firefox = {
      enable = true;
      package = lib.mkDefault null;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles.default = {
        preConfig = builtins.readFile "${inputs.betterfox}/user.js";
        settings = {
          "browser.cache.jsbc_compression_level" = 3;
          "network.ssl_tokens_cache_capacity" = 10240;
          "network.dnsCacheEntries" = 10000;
          "network.dnsCacheExpiration" = 3600;
          "browser.cache.memory.capacity" = 131072;
          "browser.tabs.min_inactive_duration_before_unload" = 300000;
          "general.smoothScroll" = true;
          "general.smoothScroll.msdPhysics.enabled" = true;
          "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
          "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
          "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
          "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
          "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
          "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
          "general.smoothScroll.currentVelocityWeighting" = "1";
          "general.smoothScroll.stopDecelerationWeighting" = "1";
          "mousewheel.default.delta_multiplier_y" = 300;
          "browser.tabs.closeWindowWithLastTab" = false;
        };
      };
    };
  };

  # --- user-apps (brave, etc.) ---------------------------------------
  den.aspects.user-apps.homeManager = { pkgs, ... }: {
    programs = {
      chromium = {
        enable = true;
        package = pkgs.brave;
      };
      bemenu.enable = true;
    };
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      app2unit waypaper dust fd pfetch ripdrag
      git p7zip filezilla telegram-desktop
      rose-pine-hyprcursor ncpamixer
      brightnessctl qbittorrent hyprprop
      wl-clipboard w3m
      nodejs rustup go gcc gnumake jq
    ];
  };

  # --- gtk-qt --------------------------------------------------------
  den.aspects.gtk-qt.homeManager = { config, ... }: {
    home.pointerCursor.enable = true;
    gtk.enable = true;
    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    qt.enable = true;
  };
}
