{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.tux = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.tuxModule
    ];
  };
  flake.nixosModules.tuxModule = {
    pkgs,
    config,
    ...
  }: {
    networking.hostName = "tux";
    imports = [
      self.nixosModules.common
      self.nixosModules.gaming
    ];
    environment.systemPackages = with pkgs; [
      discord
      obs-studio
    ];

    environment.sessionVariables = {
      ACO_COMPILER = "aco";
      QSG_RHI_BACKEND = "vulkan";
    };

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        ddcci-driver
      ];
      kernelModules = [
        "ddcci"
      ];
      kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };
    };

    zramSwap.memoryPercent = 90;

    services.sunshine = {
      enable = true;
      openFirewall = true;
      autoStart = false;
    };

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_connector", ENV{DRM_CONNECTOR_FOR}="$name"
      ACTION=="add", SUBSYSTEM=="i2c", IMPORT{parent}="DRM_CONNECTOR_FOR"
      ACTION=="add", SUBSYSTEM=="i2c", ENV{DRM_CONNECTOR_FOR}=="?*", ATTR{new_device}="ddcci 0x37"
      SUBSYSTEM=="ddcci", KERNEL=="ddcci*", GROUP="video", MODE="0660"
    '';
  };
}
