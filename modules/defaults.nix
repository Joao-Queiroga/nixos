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

    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs;
        [
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
        ]
        ++ [
          inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
        ];
      fonts.packages = with pkgs; [corefonts];
    };
  };

  den.schema.user.classes = lib.mkDefault ["homeManager"];
}
