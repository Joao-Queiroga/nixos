{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-gtk3-1.1.07"
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
  };

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
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    zfs.package = pkgs.zfs_unstable;
    extraModulePackages = with (pkgs.linuxKernel.packagesFor pkgs.linuxPackages_zen.kernel); [
      ddcci-driver
    ];
    kernelModules = [
      "ddcci"
      "i2c-dev"
    ];
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

  services.xserver.xkb.layout = "br";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
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
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [tree];
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
    };
    kdeconnect.enable = true;
    niri.enable = true;
    uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "${pkgs.writeShellScriptBin "Hyprland" ''
            #!/bin/sh
            exec Hyprland $@
          ''}/bin/Hyprland";
        };
      };
    };
    gamemode.enable = true;
    thunar.enable = true;
    neovim.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
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

  services.displayManager = {
    environment = {
      XKB_DEFAULT_LAYOUT = "br";
    };
    sddm = {
      enable = true;
      autoNumlock = true;
      package = pkgs.kdePackages.sddm;
      theme = "${
        (pkgs.sddm-astronaut.override {embeddedTheme = "black_hole";})
      }/share/sddm/themes/sddm-astronaut-theme/";
      wayland = {
        enable = true;
        compositor = "kwin";
      };
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtsvg
        qtvirtualkeyboard
      ];
    };
  };
  environment.etc."xdg/kcminputrc".text = ''
    [Keyboard]
    NumLock=0
    [Mouse]
    cursorTheme=BreezeX-RosePine-Linux
    cursorSize=24
  '';

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    override = {
      base05 = "#c0caf5";
      base09 = "#faba4a";
      base0B = "#9ece6a";
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
