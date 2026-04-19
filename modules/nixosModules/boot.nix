{inputs, ...}: {
  flake.nixosModules.boot = {pkgs, ...}: {
    imports = [];
    boot = {
      plymouth.enable = true;
      loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
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
  };
}
