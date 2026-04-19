{inputs, ...}: {
  flake.nixosModules.tuxModule = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = ["amdgpu"];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/b59005ae-34a8-4c3e-9257-0a6c2fedfdf1";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd" "noatime"];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/b59005ae-34a8-4c3e-9257-0a6c2fedfdf1";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd" "noatime"];
    };

    fileSystems."/var/log" = {
      device = "/dev/disk/by-uuid/b59005ae-34a8-4c3e-9257-0a6c2fedfdf1";
      fsType = "btrfs";
      options = ["subvol=@log" "compress=zstd" "noatime"];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/b59005ae-34a8-4c3e-9257-0a6c2fedfdf1";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress=zstd" "noatime"];
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/1FBE-A31F";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/f4d70b06-f952-40e1-9764-fc6a38f8a58f";}
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
