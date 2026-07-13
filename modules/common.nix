{ den, inputs, lib, ... }:
let
  tokyo-night = {
    base00 = "16161e"; base01 = "1a1b26"; base02 = "2f3549";
    base03 = "444b6a"; base04 = "787c99"; base05 = "c0caf5";
    base06 = "cbccd1"; base07 = "d5d6db"; base08 = "f7768e";
    base09 = "faba4a"; base0A = "e0af68"; base0B = "9ece6a";
    base0C = "7dcfff"; base0D = "7aa2f7"; base0E = "bb9af7";
    base0F = "d18616";
  };
in
{
  # ===================================================================
  # AGGREGATOR — incluído por todos os hosts
  # ===================================================================
  den.aspects.common = {
    includes = [
      den.batteries.hostname

      den.aspects.boot
      den.aspects.display
      den.aspects.firefox
      den.aspects.networking
      den.aspects.locale
      den.aspects.bluetooth
      den.aspects.graphics
      den.aspects.flatpak
      den.aspects.system-base
      den.aspects.stylix
      den.aspects.hyprland
      den.aspects.kernel
      den.aspects.shell
      den.aspects.neovim
      den.aspects.nixld
      den.aspects.apparmor
      den.aspects.autoupgrade
    ];

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        vim wget btop file kitty unzip
        ventoy-full-gtk gparted exfatprogs killall python3
      ] ++ [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.yazi
        inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
      ];
      fonts.packages = with pkgs; [ corefonts ];
    };
  };

  # --- boot ----------------------------------------------------------
  den.aspects.boot.nixos = { config, pkgs, ... }: {
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="DroidCam" video_nr=10
      '';
      plymouth.enable = true;
      loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          timeoutStyle = "hidden";
          mirroredBoots = [{
            devices = [ "nodev" ];
            path = "/boot";
            efiSysMountPoint = "/boot/efi";
            efiBootloaderId = "NixOS";
          }];
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
        timeout = 0;
      };
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet" "splash" "boot.shell_on_fail"
        "udev.log_priority=3" "rd.systemd.show_status=auto"
        "kbd.numlock=1"
      ];
    };
  };

  # --- display-manager ------------------------------------------------
  den.aspects.display.nixos = { config, pkgs, lib, ... }: {
    services.xserver.enable = true;
    environment.systemPackages = [ config.stylix.cursor.package ];
    services.displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        theme = "${inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.qylock}/share/sddm/themes/pixel-hollowknight";
        wayland.enable = true;
        extraPackages = [
          inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.qylock
        ];
        settings = {
          Theme = {
            CursorTheme = config.stylix.cursor.name;
            CursorSize = config.stylix.cursor.size;
          };
          Wayland.CompositorCommand = let
            xcfg = config.services.xserver;
            westonIni = (pkgs.formats.ini { }).generate "weston.ini" {
              libinput = {
                enable-tap = config.services.libinput.mouse.tapping;
                left-handed = config.services.libinput.mouse.leftHanded;
              };
              keyboard = {
                keymap_model = xcfg.xkb.model;
                keymap_layout = xcfg.xkb.layout;
                keymap_variant = xcfg.xkb.variant;
                keymap_options = xcfg.xkb.options;
                numlock-on = config.services.displayManager.sddm.autoNumlock;
              };
            };
          in "${lib.getExe pkgs.weston} --shell=kiosk -c ${westonIni}";
        };
      };
    };
  };

  # --- networking ----------------------------------------------------
  den.aspects.networking.nixos = {
    networking.networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    networking.firewall.checkReversePath = false;
    services.chrony = {
      enable = true;
      servers = [ "a.st1.ntp.br" "b.st1.ntp.br" "c.st1.ntp.br" "d.st1.ntp.br" ];
    };
    services.timesyncd.enable = false;
  };

  # --- locale --------------------------------------------------------
  den.aspects.locale.nixos = {
    time.timeZone = "Brazil/East";
    i18n.defaultLocale = "pt_BR.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "br-abnt2";
    };
    services.xserver.xkb.layout = "br";
    services.xserver.xkb.options = "numlock:on";
  };

  # --- bluetooth -----------------------------------------------------
  den.aspects.bluetooth = {
    nixos = {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
    };
    homeManager.services.blueman-applet.enable = true;
  };

  # --- graphics ------------------------------------------------------
  den.aspects.graphics.nixos = { pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ mesa vulkan-tools ];
    };
  };

  # --- flatpak -------------------------------------------------------
  den.aspects.flatpak.nixos.services.flatpak.enable = true;

  # --- kernel --------------------------------------------------------
  den.aspects.kernel.nixos = { pkgs, lib, ... }: {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
  };

  # --- system-base (Nix, services, misc) -----------------------------
  den.aspects.system-base.nixos = { config, pkgs, ... }: {
    imports = [ inputs.self.nixosModules.niri ];
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = true;
      permittedInsecurePackages = [ "ventoy-gtk3-1.1.12" ];
    };
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        use-xdg-base-directories = true;
        trusted-users = [ "root" "@wheel" ];

        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
      optimise.automatic = true;
    };
    programs = {
      appimage.enable = true;
      appimage.binfmt = true;
      fuse.userAllowOther = true;
      chromium.enable = true;
      droidcam.enable = true;
      kdeconnect.enable = true;
      thunar.enable = true;
      java.enable = true;
    };
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
      geoclue2.enable = true;
    };
    environment = {
      pathsToLink = [ "/share/hypr" ];
      binsh = "${pkgs.dash}/bin/dash";
    };
  };

  # --- stylix --------------------------------------------------------
  den.aspects.stylix.nixos = { config, lib, pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];
    config = {
      stylix = {
        enable = true;
        base16Scheme = {
          inherit (tokyo-night)
            base00 base01 base02 base03 base04 base05 base06 base07
            base08 base09 base0A base0B base0C base0D base0E base0F;
        };
        cursor = {
          name = "BreezeX-RosePine-Linux";
          package = pkgs.rose-pine-cursor;
          size = 27;
        };
        icons = {
          enable = true;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
          package = pkgs.papirus-icon-theme;
        };
        fonts.monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        polarity = "dark";
        targets.grub.useWallpaper = false;
        targets.chromium.enable = false;
      };
    };
  };

  # --- hyprland ------------------------------------------------------
  den.aspects.hyprland.nixos = { pkgs, ... }: {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  # --- shell (bash -> fish + zsh) ------------------------------------
  den.aspects.shell = {
    nixos = { pkgs, ... }: {
      programs = {
        bash = {
          enable = true;
          interactiveShellInit = ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec "$(command -v fish || echo ${pkgs.fish}/bin/fish)" $LOGIN_OPTION
            fi
          '';
        };
        zsh = {
          enable = true;
          enableCompletion = true;
        };
      };
    };
  };

  # --- neovim --------------------------------------------------------
  den.aspects.neovim.nixos = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      package = inputs.my-neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  # --- nix-ld --------------------------------------------------------
  den.aspects.nixld.nixos.programs.nix-ld.enable = true;

  # --- apparmor ------------------------------------------------------
  den.aspects.apparmor.nixos.security.apparmor.enable = true;

  # --- auto-upgrade --------------------------------------------------
  den.aspects.autoupgrade.nixos = {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = builtins.concatLists (
        map (name: [ "--update-input" name ]) (builtins.attrNames inputs)
      );
      dates = "2:00";
      randomizedDelaySec = "45min";
    };
  };
}
