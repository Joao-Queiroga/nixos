{
  den,
  lib,
  ...
}: {
  den.aspects.tuxnote-minimal.includes = [
    den.aspects.tuxnote-hardware
    den.aspects.boot
    den.aspects.networking
  ];

  den.aspects.tuxnote-minimal.nixos = {pkgs, ...}: {
    boot.extraModulePackages = lib.mkForce [];
    boot.kernelModules = lib.mkForce [];
    boot.extraModprobeConfig = lib.mkForce "";
    boot.plymouth.enable = lib.mkForce false;
    boot.kernelParams = lib.mkForce [];

    environment.systemPackages = with pkgs; [
      btrfs-progs
      curl
      fish
      git
      pciutils
      util-linux
      vim
      wget
      usbutils
    ];

    nix.settings = {
      max-jobs = 1;
      cores = 1;
    };

    programs.fish.enable = true;
    users.users.root.shell = pkgs.fish;
  };
}
