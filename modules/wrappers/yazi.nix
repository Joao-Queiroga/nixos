{
  self,
  inputs,
  ...
}: {
  flake.wrappers.yazi = {
    pkgs,
    wlib,
    lib,
    config,
    ...
  }: {
    imports = [wlib.wrapperModules.yazi];
    extraPackages = with pkgs; [ripdrag glow glib];
    plugins = with pkgs.yaziPlugins; {
      smart-enter = smart-enter;
      drag = inputs.drag;
      gvfs = inputs.gvfs-yazi;
      git = git;
      starship = starship;
      full-border = full-border;
    };
    settings.yazi = {
      opener = {
        jar = [
          {
            run = ''java -jar "$1"'';
            orphan = true;
            desc = "Open jar file";
          }
        ];
      };
      open = {
        prepend_rules = [
          {
            name = "*.jar";
            use = ["jar"];
          }
        ];
      };
    };
    settings.keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "$";
            run = "shell --block --confirm fish";
            desc = "Open shell";
          }
          {
            on = "<C-d>";
            run = "plugin drag";
            desc = "Drag files";
          }
          {
            on = ["M" "m"];
            run = "plugin gvfs -- select-then-mount --jump";
            desc = "Select device to mount and jump to its mount point";
          }

          {
            on = ["M" "R"];
            run = "plugin gvfs -- remount-current-cwd-device";
            desc = "Remount device under cwd";
          }
          {
            on = ["M" "u"];
            run = "plugin gvfs -- select-then-unmount --eject";
            desc = "Select device then eject";
          }
          {
            on = ["M" "U"];
            run = "plugin gvfs -- select-then-unmount --eject --force";
            desc = "Select device then force to eject/unmount";
          }
          {
            on = ["M" "a"];
            run = "plugin gvfs -- add-mount";
            desc = "Add a GVFS mount URI";
          }
          {
            on = ["M" "e"];
            run = "plugin gvfs -- edit-mount";
            desc = "Edit a GVFS mount URI";
          }
          {
            on = ["M" "r"];
            run = "plugin gvfs -- remove-mount";
            desc = "Remove a GVFS mount URI";
          }
          {
            on = ["g" "m"];
            run = "plugin gvfs -- jump-to-device";
            desc = "Select device then jump to its mount point";
          }
          {
            on = ["`" "`"];
            run = "plugin gvfs -- jump-back-prev-cwd";
            desc = "Jump back to the position before jumped to device";
          }
          {
            on = ["M" "t"];
            run = "plugin gvfs -- automount-when-cd";
            desc = "Enable automount when cd to device under cwd";
          }
          {
            on = ["M" "T"];
            run = "plugin gvfs -- automount-when-cd --disabled";
            desc = "Disable automount when cd to device under cwd";
          }
        ];
      };
    };
    settings.theme =
      {
        icon.prepend_dirs = [
          {
            name = "Área de trabalho";
            text = "";
            fg = "#00bcd4";
          }
          {
            name = "Projects";
            text = "";
            fg = "#00bcd4";
          }
          {
            name = "Documentos";
            text = "";
            fg = "#00bcd4";
          }
          {
            name = "Bilbioteca";
            text = "";
            fg = "#00bcd4";
          }
          {
            name = "Músicas";
            text = "";
            fg = "#00bcd4";
          }
          {
            name = "Imagens";
            text = "";
            fg = "#00bcd4";
          }
          {
            name = "Público";
            text = "";
            fg = "#00bcd4";
          }
          {
            name = "Vídeos";
            text = "";
            fg = "#00bcd4";
          }
        ];
      }
      // self.yaziColors;
    constructFiles = {
      luaInit = {
        content =
          /*
          lua
          */
          ''
            require("starship"):setup()
            require("full-border"):setup()
            require("git"):setup()
            require("zoxide"):setup({
            	update_db = true,
            })
            require("gvfs"):setup()
          '';
        relPath = "${config.binName}-config/init.lua";
      };
    };
  };
  # Coppied from stylix yazi module
  flake.yaziColors = with self.theme; let
    mkFg = fg: {inherit fg;};
    mkBg = bg: {inherit bg;};
    mkBoth = fg: bg: {inherit fg bg;};
    mkSame = c: (mkBoth c c);
  in {
    mgr = {
      cwd = mkFg base0C;
      find_keyword =
        (mkFg base0B)
        // {
          bold = true;
        };
      find_position = mkFg base0E;
      marker_selected = mkSame base0A;
      marker_copied = mkSame base0B;
      marker_cut = mkSame base08;
      border_style = mkFg base04;

      count_copied = mkBoth base00 base0B;
      count_cut = mkBoth base00 base08;
      count_selected = mkBoth base00 base0A;
    };

    indicator = rec {
      current =
        (mkBg base02)
        // {
          bold = true;
        };
      preview = current;
    };

    tabs = {
      active =
        (mkBoth base00 base0D)
        // {
          bold = true;
        };
      inactive = mkBoth base0D base01;
    };

    mode = {
      normal_main =
        (mkBoth base00 base0D)
        // {
          bold = true;
        };
      normal_alt = mkBoth base0D base00;
      select_main =
        (mkBoth base00 base0B)
        // {
          bold = true;
        };
      select_alt = mkBoth base0B base00;
      unset_main =
        (mkBoth base00 base0F)
        // {
          bold = true;
        };
      unset_alt = mkBoth base0F base00;
    };

    status = {
      progress_label = mkBoth base05 base00;
      progress_normal = mkBoth base05 base00;
      progress_error = mkBoth base08 base00;
      perm_type = mkFg base0D;
      perm_read = mkFg base0A;
      perm_write = mkFg base08;
      perm_exec = mkFg base0B;
      perm_sep = mkFg base0C;
    };

    pick = {
      border = mkFg base0D;
      active = mkFg base0E;
      inactive = mkFg base05;
    };

    input = {
      border = mkFg base0D;
      title = mkFg base05;
      value = mkFg base05;
      selected = mkBg base03;
    };

    completion = {
      border = mkFg base0D;
      active = mkBoth base0E base03;
      inactive = mkFg base05;
    };

    tasks = {
      border = mkFg base0D;
      title = mkFg base05;
      hovebase08 = mkBoth base05 base03;
    };

    which = {
      mask = mkBg base02;
      cand = mkFg base0C;
      rest = mkFg base0F;
      desc = mkFg base05;
      separator_style = mkFg base04;
    };

    help = {
      on = mkFg base0E;
      run = mkFg base0C;
      desc = mkFg base05;
      hovebase08 = mkBoth base05 base03;
      footer = mkFg base05;
    };

    # https://github.com/sxyazi/yazi/blob/main/yazi-config/preset/theme.toml
    filetype.rules = let
      mkRule = mime: fg: {inherit mime fg;};
    in [
      (mkRule "image/*" base0C)
      (mkRule "video/*" base0A)
      (mkRule "audio/*" base0A)

      (mkRule "application/zip" base0E)
      (mkRule "application/gzip" base0E)
      (mkRule "application/tar" base0E)
      (mkRule "application/bzip" base0E)
      (mkRule "application/bzip2" base0E)
      (mkRule "application/7z-compressed" base0E)
      (mkRule "application/rar" base0E)
      (mkRule "application/xz" base0E)

      (mkRule "application/doc" base0B)
      (mkRule "application/pdf" base0B)
      (mkRule "application/rtf" base0B)
      (mkRule "application/vnd.*" base0B)

      # Use url rule for folders as folder mime types do not get checked until they are hovebase08
      {
        url = "*/";
        fg = base0D;
        bold = true;
      }
      (mkRule "*" base05)
    ];
  };
}
