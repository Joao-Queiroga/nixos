{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-gtk3-1.1.10"
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.use-xdg-base-directories = true;
  nix.settings = {
    trusted-users = ["root" "@wheel"];
    substituters = ["https://hyprland.cachix.org" "https://niri.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org" "https://niri.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="];
    lazy-trees = true;
  };
  nix.optimise.automatic = true;

  boot = {
    plymouth.enable = true;
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        zfsSupport = true;
        timeoutStyle = "hidden";
        mirroredBoots = [
          {
            devices = ["nodev"];
            path = "/boot";
            efiSysMountPoint = "/boot/efi";
            efiBootloaderId = "NixOS";
          }
        ];
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
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "kbd.numlock=1"
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    extraModulePackages = with config.boot.kernelPackages; [
      ddcci-driver
    ];
    kernelModules = [
      "ddcci"
    ];
    zfs.package = pkgs.zfs_unstable;
  };

  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;

  time.timeZone = "Brazil/East";

  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.geoclue2.enable = true;

  services.xserver.xkb.layout = "br";
  services.xserver.xkb.options = "numlock:on";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-tools
    ];
  };

  programs.bash = {
    enable = true;
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec "$(command -v fish || echo ${pkgs.fish}/bin/fish)" $LOGIN_OPTION
      fi
    '';
  };

  users.users.joaoqueiroga = {
    isNormalUser = true;
    description = "João Queiroga";
    extraGroups = [
      "wheel"
      "networkmanager"
      "gamemode"
    ];
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    chromium.enable = true;
    nix-ld.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    kdeconnect.enable = true;
    niri.enable = true;
    uwsm.waylandCompositors.hyprland.binPath = lib.mkForce "${pkgs.writeShellScriptBin "Hyprland" ''
      #!/bin/sh
      exec start-hyprland "$@"
    ''}/bin/Hyprland";
    thunar.enable = true;
    neovim.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    wineWowPackages.waylandFull
    btop
    file
    kitty
    unzip
    ventoy-full-gtk
    gparted
    exfatprogs
    rose-pine-cursor
    killall
  ];
  environment.binsh = "${pkgs.dash}/bin/dash";

  services.displayManager = {
    environment = {
      XKB_DEFAULT_LAYOUT = "br";
    };
    sddm = {
      enable = true;
      autoNumlock = true;
      theme = "${
        (pkgs.sddm-astronaut.override {embeddedTheme = "black_hole";})
      }/share/sddm/themes/sddm-astronaut-theme/";
      wayland.enable = true;
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtsvg
        qtvirtualkeyboard
      ];
      settings = {
        Theme = {
          CursorTheme = config.stylix.cursor.name;
          CursorSize = config.stylix.cursor.size;
        };
        Wayland.CompositorCommand = let
          xcfg = config.services.xserver;
          westonIni = (pkgs.formats.ini {}).generate "weston.ini" {
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

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    override = {
      base05 = "#c0caf5";
      base09 = "#faba4a";
      base0B = "#9ece6a";
    };
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 27;
    };
    polarity = "dark";
    targets.grub.useWallpaper = false;
    targets.chromium.enable = false;
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = builtins.concatLists (
      map (name: [
        "--update-input"
        name
      ]) (builtins.attrNames inputs)
    );
    dates = "2:00";
    randomizedDelaySec = "45min";
  };

  system.stateVersion = "25.05";
}
