{
  lib,
  den,
  inputs,
  ...
}: {
  den.default = {
    nixos.system.stateVersion = "26.05";
    homeManager.home.stateVersion = "26.05";

    includes = [
      den.batteries.define-user
      den.batteries.inputs'
      den.batteries.self'
    ];
  };

  den.aspects.common = {
    includes = [
      den.aspects.minimal

      den.aspects.display
      den.aspects.bluetooth
      den.aspects.graphics
      den.aspects.flatpak
      den.aspects.stylix
      den.aspects.neovim
      den.aspects.nixld
      den.aspects.apparmor
      den.aspects.autoupgrade
      den.aspects.comma
      den.aspects.desktop-base
    ];

    nixos = {pkgs, ...}: {
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
        killall
        python3
      ];
      fonts.packages = with pkgs; [corefonts];
    };
  };

  den.schema.user.classes = lib.mkDefault ["homeManager"];

  den.schema.host = {lib, ...}: {
    options.strong = lib.mkEnableOption "whether this is a strong (high-performance) host";
  };
}
