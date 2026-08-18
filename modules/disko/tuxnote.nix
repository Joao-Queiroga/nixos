{
  inputs,
  den,
  ...
}: {
  den.aspects.tuxnote-hardware.nixos = {config, lib, modulesPath, ...}: {
    imports = [
      inputs.disko.nixosModules.disko
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = ["fmask=0022" "dmask=0022"];
            };
          };

          swap = {
            size = "8G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = ["compress=zstd:1" "lazytime" "discard=async" "autodefrag"];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd:1" "lazytime" "discard=async" "autodefrag"];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd:1" "lazytime" "discard=async" "autodefrag"];
                };
                "@var" = {
                  mountpoint = "/var";
                  mountOptions = ["compress=zstd:1" "lazytime" "discard=async" "autodefrag"];
                };
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = ["compress=zstd:1" "lazytime" "discard=async" "autodefrag"];
                };
                "@root" = {
                  mountpoint = "/root";
                  mountOptions = ["compress=zstd:1" "lazytime" "discard=async" "autodefrag"];
                };
              };
            };
          };
        };
      };
    };

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
