{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [./hardware-configuration.nix];

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

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  networking.hostId = "7df2bda7";

  programs.steam = {
    enable = true;
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

  # systemd.services."ddcci@" = {
  #   unitConfig = {
  #     Description = "ddcci service for device %i";
  #     After = "multi-user.target";
  #     Before = "shutdown.target";
  #     Conflicts = "shutdown.target";
  #   };
  #   serviceConfig = {
  #     ExecStart = ''
  #       ${pkgs.bash}/bin/bash -c 'echo Trying to attach ddcci to %i && success=0 && i=0 && id=$(echo %i | cut -d "-" -f 2) && while ((success < 1)) && ((i++ < 5)); do ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $id && { success=1 && echo ddcci 0x37 > /sys/bus/i2c/devices/%i/new_device && echo "ddcci attached to %i"; } || sleep 5; done && modprobe ddcci' '';
  #     Type = "oneshot";
  #     Restart = "no";
  #     RemainAfterExit = "yes";
  #     StandardOutput = "journal";
  #     StandardError = "journal";
  #   };
  # };
  #
  # services.udev.extraRules = ''
  #    SUBSYSTEM=="i2c-dev", ACTION=="add",\
  #   ATTR{name}=="AMDGPU DM aux hw bus *",\
  #   TAG+="ddcci",\
  #   TAG+="systemd",\
  #   ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
  # '';
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="drm", ENV{DEVTYPE}=="drm_connector", ENV{DRM_CONNECTOR_FOR}="$name"
    ACTION=="add", SUBSYSTEM=="i2c", IMPORT{parent}="DRM_CONNECTOR_FOR"
    ACTION=="add", SUBSYSTEM=="i2c", ENV{DRM_CONNECTOR_FOR}=="?*", ATTR{new_device}="ddcci 0x37"
    SUBSYSTEM=="ddcci", KERNEL=="ddcci*", GROUP="video", MODE="0660"
  '';
}
