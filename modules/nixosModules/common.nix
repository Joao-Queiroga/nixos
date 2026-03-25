{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.common = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.boot
      self.nixosModules.niri
      self.nixosModules.displayManager
      inputs.determinate.nixosModules.default
      inputs.stylix.nixosModules.stylix
    ];
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
      substituters = ["https://hyprland.cachix.org" "https://attic.xuyh0120.win/lantian"];
      trusted-substituters = ["https://hyprland.cachix.org" "https://attic.xuyh0120.win/lantian"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="];
      lazy-trees = true;
    };
    nix.optimise.automatic = true;
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];

    boot = {
      kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
      zfs.package = config.boot.kernelPackages.zfs_cachyos;
    };

    networking.networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
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
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    services.xserver.xkb.layout = "br";
    services.xserver.xkb.options = "numlock:on";

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    services.flatpak.enable = true;

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

      uwsm.waylandCompositors.hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = lib.mkForce "${pkgs.writeShellScriptBin "Hyprland" ''
          #!/bin/sh
          exec start-hyprland "$@"
        ''}/bin/Hyprland";
      };
      thunar.enable = true;
      neovim.enable = true;
    };

    environment.systemPackages = with pkgs; [
      vim
      wget
      # wineWowPackages.waylandFull
      btop
      file
      kitty
      unzip
      ventoy-full-gtk
      gparted
      exfatprogs
      killall
    ];
    environment.binsh = "${pkgs.dash}/bin/dash";

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
  };
}
