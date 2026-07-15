{...}: {
  den.aspects.yazi.homeManager = {pkgs, ...}: {
    programs.yazi = {
      enable = true;
      plugins = with pkgs.yaziPlugins; {
        smart-enter = smart-enter;
        drag = drag;
        gvfs = gvfs;
        git = git;
        starship = starship;
        full-border = full-border;
      };
      initLua =
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
      settings = {
        plugin = {
          prepend_preloaders = [
            {
              mime = "image/svg+xml";
              run = "magick";
            }
          ];
          prepend_previewers = [
            {
              mime = "image/svg+xml";
              run = "magick";
            }
          ];
        };
        opener = {
          jar = [
            {
              run = ''java -jar "$1"'';
              orphan = true;
              desc = "Open jar file";
            }
          ];
          svg = [
            {
              run = ''imv -b#ffffff "$1"'';
              orphan = true;
              desc = "Open svg";
            }
          ];
        };
        open = {
          prepend_rules = [
            {
              url = "*.jar";
              use = ["jar"];
            }
            {
              mime = "image/svg+xml";
              use = ["svg"];
            }
          ];
        };
      };
      keymap = {
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
      theme = {
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
      };
    };
  };
}
