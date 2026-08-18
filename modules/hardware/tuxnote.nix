{
  den,
  lib,
  ...
}: {
  den.aspects.tuxnote-hardware.nixos = {config, pkgs, lib, modulesPath, ...}: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/c1922fc6-523f-4fd0-bebf-465634a6e147";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd:1" "lazytime" "discard=async" "autodefrag"];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/c1922fc6-523f-4fd0-bebf-465634a6e147";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd:1"
        "lazytime"
        "discard=async"
        "autodefrag"
      ];
    };

    fileSystems."/var" = {
      device = "/dev/disk/by-uuid/c1922fc6-523f-4fd0-bebf-465634a6e147";
      fsType = "btrfs";
      options = [
        "subvol=@var"
        "compress=zstd:1"
        "lazytime"
        "discard=async"
        "autodefrag"
      ];
    };

    fileSystems."/var/log" = {
      device = "/dev/disk/by-uuid/c1922fc6-523f-4fd0-bebf-465634a6e147";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "compress=zstd:1"
        "lazytime"
        "discard=async"
        "autodefrag"
      ];
    };

    fileSystems."/root" = {
      device = "/dev/disk/by-uuid/c1922fc6-523f-4fd0-bebf-465634a6e147";
      fsType = "btrfs";
      options = [
        "subvol=@root"
        "compress=zstd:1"
        "lazytime"
        "discard=async"
        "autodefrag"
      ];
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/64B8-EF51";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [{device = "/dev/disk/by-uuid/29525ea8-917c-4e5c-a1b6-d2fa56a9b656";}];

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
