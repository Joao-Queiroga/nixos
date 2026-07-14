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

  den.aspects.shell-fish.homeManager = { config, pkgs, ... }: {
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting.body = "${pkgs.pfetch-rs}/bin/pfetch";
        starship_transient_prompt_func.body = "starship module character";
      };
      binds = {
        up = { command = "_atuin_bind_up"; mode = "default"; };
        "up-insert" = { name = "up"; command = "_atuin_bind_up"; mode = "insert"; };
        "ctrl-k" = { command = "_atuin_bind_up"; mode = "default"; };
        "ctrl-k-insert" = { name = "ctrl-k"; command = "_atuin_bind_up"; mode = "insert"; };
        enter = { command = [ "expand-abbr" "execute" ]; mode = "default"; };
        "enter-insert" = { name = "enter"; command = [ "expand-abbr" "execute" ]; mode = "insert"; };
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

  den.aspects.shell-aliases.homeManager = { pkgs, ... }: {
    home.shellAliases = {
      nvimconf = "nvim ~/.config/nvim/init.lua";
      cat = "bat"; tree = "eza --tree"; cd = "z";
      grep = "rg"; du = "${pkgs.dust}/bin/dust";
    };
  };

  den.aspects.cli-tools.homeManager = { pkgs, ... }: {
    programs = {
      zoxide.enable = true;
      bat.enable = true;
      ripgrep = { enable = true; arguments = [ "--hidden" "--smart-case" ]; };
      carapace.enable = true;
      fzf = { enable = true; historyWidget.command = ""; };
      eza = { enable = true; icons = "auto"; };
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
        yank vim-tmux-navigator sensible
        { plugin = tokyo-night-tmux; extraConfig = "set -g @tokyo-night-tmux_window_id_style none"; }
      ];
    };
  };
}
