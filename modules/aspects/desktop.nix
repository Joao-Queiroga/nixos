{den, ...}: {
  den.aspects.desktop = {
    includes = [
      den.aspects.common
      den.aspects.periferics
    ];

    nixos = {
      pkgs,
      config,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        ddcutil
        discord
        obs-studio
      ];
      environment.sessionVariables = {
        ACO_COMPILER = "aco";
        QSG_RHI_BACKEND = "vulkan";
      };
      services.ddccontrol.enable = true;
      services.ddccontrol.package = pkgs.ddcutil-service;
      programs.droidcam.enable = true;
      boot = {
        extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
        kernelModules = ["v4l2loopback"];
        extraModprobeConfig = ''
          options v4l2loopback exclusive_caps=1 card_label="DroidCam" video_nr=10
        '';
      };
    };
  };
}
