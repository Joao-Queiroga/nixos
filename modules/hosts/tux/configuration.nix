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
    ];
    environment.systemPackages = with pkgs; [
      lsfg-vk
      lsfg-vk-ui
      vkbasalt
      vkbasalt-cli
      cemu
      prismlauncher
      mangohud
      discord
      obs-studio
    ];

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        ddcci-driver
      ];
      kernelModules = [
        "ddcci"
      ];
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    networking.hostId = "7df2bda7";

    programs.steam = {
      enable = true;
      package = pkgs.steam;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    services.lact.enable = true;

    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "high";
        };
      };
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
