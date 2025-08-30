{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "tux";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
    overdrive.enable = true;
  };

  systemd.services."ddcci@" = {
    unitConfig = {
      Description = "ddcci service for device %i";
      After = "multi-user.target";
      Before = "shutdown.target";
      Conflicts = "shutdown.target";
    };
    serviceConfig = {
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c 'echo Trying to attach ddcci to %i && success=0 && i=0 && id=$(echo %i | cut -d "-" -f 2) && while ((success < 1)) && ((i++ < 5)); do ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $id && { success=1 && echo ddcci 0x37 > /sys/bus/i2c/devices/%i/new_device && echo "ddcci attached to %i"; } || sleep 5; done' '';
      Type = "oneshot";
      Restart = "no";
      RemainAfterExit = "yes";
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  services.udev.extraRules = ''
      SUBSYSTEM=="i2c-dev", ACTION=="add",\
    	ATTR{name}=="AMDGPU DM aux hw bus *",\
    	TAG+="ddcci",\
    	TAG+="systemd",\
    	ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
  '';
}
