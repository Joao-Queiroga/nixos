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

    services.ddccontrol.enable = true;

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        ddcci-driver
      ];
      kernelModules = [
        "ddcci"
      ];
      kernelParams = ["amdgpu.gttsize=4096" "transparent_hugepage=madvise"];
      kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
        "vm.min_free_kbytes" = 524288;
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;
        "vm.compaction_proactiveness" = 20;
        "vm.lru_gen.enabled" = 7;
        "vm.lru_gen.min_ttl_ms" = 1000;
      };
    };
    zramSwap.memoryPercent = 75;
    services.earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 5;
      extraArgs = [
        "-m 8,4"
        "-s 8,4"
      ];
      enableNotifications = true;
    };

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
