{ den, ... }: {
  den.aspects.user-apps = {
    includes = [ den.aspects.gtk-qt ];

    homeManager = { pkgs, ... }: {
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
  };

  den.aspects.gtk-qt.homeManager = { config, ... }: {
    home.pointerCursor.enable = true;
    gtk.enable = true;
    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    qt.enable = true;
  };
}
