{inputs, ...}: {
  flake.nixosModules.gaming = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      lsfg-vk
      lsfg-vk-ui
      vkbasalt
      vkbasalt-cli
      cemu
      prismlauncher
      mangohud
      heroic
    ];

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

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
  };
}
