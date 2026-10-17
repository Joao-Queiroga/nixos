{ den, ... }: {
  den.aspects.shells = {
    includes = [
      den.aspects.shell-fish
      den.aspects.shell-aliases
      den.aspects.starship
      den.aspects.atuin
      den.aspects.tmux
      den.aspects.cli-tools
    ];
  };

  den.aspects.shell-fish.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
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
            command = [
              "expand-abbr"
              "execute"
            ];
            mode = "default";
          };
          "enter-insert" = {
            name = "enter";
            command = [
              "expand-abbr"
              "execute"
            ];
            mode = "insert";
          };
        };
        interactiveShellInit = ''
          set -U fish_color_command cyan
          fish_vi_key_bindings
        '';
        plugins = with pkgs.fishPlugins; [
          {
            name = "fishbang";
            src = fishbang.src;
          }
          {
            name = "autopair";
            src = autopair.src;
          }
          {
            name = "async-prompt";
            src = async-prompt.src;
          }
        ];
      };
      programs.zsh = {
        enable = true;
        autocd = true;
        localVariables = {
          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=${config.lib.stylix.colors.withHashtag.base04}";
        };
        dotDir = "${config.xdg.configHome}/zsh";
        antidote = {
          enable = true;
          plugins = with pkgs; [
            "${zsh-autopair.src} kind:defer"
            "${zsh-fast-syntax-highlighting.src} kind:defer"
            "${zsh-history-substring-search.src} kind:defer"
            "${zsh-autosuggestions.src} kind:defer"
            "${zsh-vi-mode.src}"
          ];
        };
        completionInit = /* zsh */ ''
          autoload -Uz compinit
          _zcd=(''${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24))
          if (( $#_zcd )) || [[ ! -f ''${ZDOTDIR:-$HOME}/.zcompdump ]]; then
            compinit
          else
            compinit -C
          fi
          unset _zcd
        '';
        initContent = lib.mkMerge [
          (lib.mkBefore /* zsh */ ''
            zstyle ':antidote:static' zcompile 'yes'
            zstyle ':antidote:defer' bundle '${pkgs.zsh-defer.src}'
          '')
          (lib.mkAfter (
            let
              theme = toString (
                pkgs.writeText "stylix.ini" (
                  with config.lib.stylix.colors.withHashtag;
                  /* ini */ ''
                    [base]
                    default          = none
                    secondary        =
                    unknown-token    = ${base08},bold
                    commandseparator = none
                    redirection      = none
                    exec-descriptor  = ${base0A},bold
                    comment          = ${base03}
                    correct-subtle   = ${base0C}
                    incorrect-subtle = ${base08}
                    subtle-separator = ${base0C}
                    subtle-bg        = bg:${base02}
                    here-string-tri  = ${base0A}
                    here-string-text = bg:${base02}
                    here-string-var  = ${base0C},bg:${base02}

                    [command-point]
                    reserved-word   = ${base0A}
                    subcommand      = ${base0A}
                    alias           = ${base0C}
                    suffix-alias    = ${base0C}
                    global-alias    = ${base0E}
                    builtin         = ${base0C}
                    function        = ${base0C}
                    command         = ${base0C}
                    precommand      = ${base0C}
                    hashed-command  = ${base0C}
                    single-sq-bracket = ${base0C}
                    double-sq-bracket = ${base0C}
                    double-paren    = ${base0A}

                    [paths]
                    path          = ${base04},underline
                    path-to-dir   = ${base04},underline,bold
                    globbing      = ${base0E}
                    globbing-ext  = ${base0E},bold

                    [brackets]
                    paired-bracket  = bg:${base02}
                    bracket-level-1 = ${base0B},bold
                    bracket-level-2 = ${base0A},bold
                    bracket-level-3 = ${base0C},bold

                    [arguments]
                    single-hyphen-option       = ${base0A}
                    double-hyphen-option       = ${base0A}
                    back-quoted-argument       = none
                    single-quoted-argument     = ${base0B}
                    double-quoted-argument     = ${base0B}
                    dollar-quoted-argument     = ${base0B}
                    optarg-string              = ${base0B}
                    optarg-number              = ${base0D}

                    [in-string]
                    back-dollar-quoted-argument           = ${base0C}
                    back-or-dollar-double-quoted-argument = ${base0C}

                    [other]
                    variable             = ${base09}
                    assign               = none
                    assign-array-bracket = ${base0B}
                    history-expansion    = ${base0E},bold
                    recursive-base       = none

                    [math]
                    mathvar = ${base0D},bold
                    mathnum = ${base0D}
                    matherr = ${base08},bold

                    [for-loop]
                    for-loop-variable  = none
                    for-loop-number    = ${base0D}
                    for-loop-operator  = ${base0A}
                    for-loop-separator = ${base0A},bold

                    [case]
                    case-input       = ${base0C}
                    case-parentheses = ${base0A}
                    case-condition   = bg:${base02}
                  ''
                )
              );
            in
            /* zsh */ ''
              _late_binds() {
                bindkey '^?' autopair-delete
                bindkey "^[[A" history-substring-search-up
                bindkey "^[[B" history-substring-search-down
              }
              bindkey '^?' autopair-delete
              bindkey "^[[A" history-substring-search-up
              bindkey "^[[B" history-substring-search-down
              zsh-defer fast-theme -q ${toString theme}
              zsh-defer _late_binds
              ${lib.getExe pkgs.pfetch-rs}
            ''
          ))
        ];
      };
    };

  den.aspects.shell-aliases.homeManager = { pkgs, ... }: {
    home.shellAliases = {
      cat = "bat";
      tree = "eza --tree";
      cd = "z";
      grep = "rg";
      du = "${pkgs.dust}/bin/dust";
    };
  };

  den.aspects.cli-tools.homeManager = { pkgs, ... }: {
    programs = {
      zoxide.enable = true;
      bat.enable = true;
      ripgrep = {
        enable = true;
        arguments = [
          "--hidden"
          "--smart-case"
        ];
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
        {
          plugin = tokyo-night-tmux;
          extraConfig = "set -g @tokyo-night-tmux_window_id_style none";
        }
      ];
    };
  };
}
