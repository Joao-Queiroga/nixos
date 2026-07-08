{inputs, ...}: {
  flake.nixosModules.boot = {
    pkgs,
    config,
    ...
  }: {
    imports = [];
    boot = {
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      kernelModules = ["v4l2loopback"];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="DroidCam" video_nr=10
      '';
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
