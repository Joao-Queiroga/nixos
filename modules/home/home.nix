{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations."joaoqueiroga" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [
      self.homeModules.main
    ];
  };
  flake.homeModules.main = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      self.homeModules.firefox
      self.homeModules.dirColors
      self.homeModules.shell
      self.homeModules.hyprland
      self.homeModules.vars
      self.homeModules.terminals
      self.homeModules.services
    ];
    home.username = "joaoqueiroga";
    home.homeDirectory = "/home/joaoqueiroga";

    home.stateVersion = "26.05";

    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      app2unit
      waypaper
      dust
      fd
      pfetch
      ripdrag
      git
      p7zip
      filezilla
      telegram-desktop
      rose-pine-hyprcursor
      ncpamixer
      nodejs
      rustup
      go
      brightnessctl
      qbittorrent
      hyprprop
      wl-clipboard
      gcc
      w3m
      gnumake
      jq
    ];

    programs = {
      chromium = {
        enable = true;
        package = pkgs.brave;
      };
      bemenu.enable = true;
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
    };

    gtk.enable = true;
    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    qt.enable = true;

    programs.home-manager.enable = true;
  };
}
