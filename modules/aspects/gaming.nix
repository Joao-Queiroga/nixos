{ den, ... }: {
  den.aspects.gaming = {
    includes = [ den.aspects.zram ];

    nixos = { pkgs, ... }: {
      zramSwap.memoryPercent = 75;

      boot.kernelParams = [ "transparent_hugepage=madvise" ];
      boot.kernel.sysctl = {
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

      hardware.amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        overdrive.enable = true;
      };

      services.lact.enable = true;

      programs = {
        steam = {
          enable = true;
          package = pkgs.steam;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };
        gamescope = {
          enable = true;
          capSysNice = true;
        };
        gamemode = {
          enable = true;
          enableRenice = true;
          settings = {
            general.renice = 10;
            gpu = {
              apply_gpu_optimisations = "accept-responsibility";
              gpu_device = 1;
              amd_performance_level = "high";
            };
          };
        };
      };

      environment.systemPackages = with pkgs; [
        lsfg-vk lsfg-vk-ui vkbasalt vkbasalt-cli
        cemu prismlauncher mangohud heroic
      ];
    };
  };
}
