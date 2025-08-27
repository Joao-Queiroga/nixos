# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      timeoutStyle = "hidden";
      extraConfig = ''
        set timeout=1
      '';
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
  };

  # Use latest kernel.
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    extraModulePackages = [
      (pkgs.linuxKernel.packagesFor
        pkgs.linuxPackages_cachyos.kernel).ddcci-driver
    ];
    kernelModules = [ "ddcci" "i2c-dev" ];
  };

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Brazil/East";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "br";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    #pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ mesa vulkan-tools ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.joaoqueiroga = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "nordvpn" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ tree ];
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
    };
    nix-ld.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    gamemode.enable = true;
    thunar.enable = true;
    neovim.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [ vim wget btop file kitty unzip ];
  environment.variables = { XKB_DEFAULT_LAYOUT = "br"; };

  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      package = pkgs.kdePackages.sddm;
      theme = "${
          (pkgs.sddm-astronaut.override { embeddedTheme = "black_hole"; })
        }/share/sddm/themes/sddm-astronaut-theme/";
      wayland = { enable = true; };
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtsvg
        qtvirtualkeyboard
      ];
    };
  };

  chaotic = { nordvpn.enable = true; };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    checkReversePath = false;
    allowedTCPPorts = [ 443 ];
    allowedUDPPorts = [ 1194 ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
