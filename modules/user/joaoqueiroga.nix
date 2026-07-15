{den, ...}: {
  den.aspects.joaoqueiroga = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")

      den.aspects.shells
      den.aspects.kitty
      den.aspects.dircolors
      den.aspects.env-vars
      den.aspects.user-services
      den.aspects.hyprland-user
      den.aspects.firefox
      den.aspects.user-apps
      den.aspects.yazi
    ];

    homeManager = {
      config,
      pkgs,
      ...
    }: {
      home.username = "joaoqueiroga";
      home.homeDirectory = "/home/joaoqueiroga";

      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
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
}
