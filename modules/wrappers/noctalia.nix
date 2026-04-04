{
  self,
  inputs,
  ...
}: {
  flake.wrappers.noctalia-shell = {
    pkgs,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.noctalia-shell];
    extraPackages = [];
    outOfStoreConfig = ".config/noctalia/";
    settings = {
      settingsVersion = 59;
      appLauncher = {
        iconMode = "native";
        terminalCommand = "kitty -1 -e";
        showCategories = false;
        overviewLayer = true;
      };
      bar = {
        density = "comfortable";
        barType = "framed";
        widgets = {
          center = [
            {
              id = "Clock";
            }
          ];
          left = [
            {
              id = "Launcher";
            }
            {
              emptyColor = "none";
              focusedColor = "secondary";
              id = "Workspace";
              followFocusedScreen = false;
              occupiedColor = "primary";
              labelMode = "none";
              pillSize = 0.7;
            }
            {
              id = "SystemMonitor";
            }
            {
              colorizeIcons = false;
              hideMode = "hidden";
              id = "ActiveWindow";
              maxWidth = 145;
              scrollingMode = "hover";
              showIcon = true;
              textColor = "none";
              useFixedWidth = false;
            }
            {
              id = "MediaMini";
            }
          ];
          right = [
            {
              drawerEnabled = false;
              id = "Tray";
            }
            # {
            #   id = "plugin:kde-connect";
            # }
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };
      general = {
        showSessionButtonsOnLockScreen = true;
      };
      dock = {
        groupApps = true;
      };
      idle = {
        enabled = true;
      };
      osd = {
        enabled = true;
        enabledTypes = [0 1];
      };
      colorSchemes = {
        darkMode = true;
        predefinedScheme = "";
        useWallpaperColors = false;
      };
      wallpaper = {
        DP-1 = ".config/.background";
        eDP-1 = ".config/.background";
        HDMI-A-1 = ".config/.background";
      };
    };
    colors = {
      "mError" = "#f7768e";
      "mHover" = "#2980b9";
      "mOnError" = "#16161e";
      "mOnHover" = "#16161e";
      "mOnPrimary" = "#16161e";
      "mOnSecondary" = "#16161e";
      "mOnSurface" = "#c0caf5";
      "mOnSurfaceVariant" = "#9aa5ce";
      "mOnTertiary" = "#16161e";
      "mOutline" = "#353d57";
      "mPrimary" = "#7aa2f7";
      "mSecondary" = "#bb9af7";
      "mShadow" = "#15161e";
      "mSurface" = "#1a1b26";
      "mSurfaceVariant" = "#24283b";
      "mTertiary" = "#9ece6a";
    };
  };
}
