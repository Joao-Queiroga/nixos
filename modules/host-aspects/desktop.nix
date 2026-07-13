{ den, ... }: {
  den.aspects.tux.includes = [
    den.aspects.common
    den.aspects.tux-hardware
    den.aspects.gaming
    den.aspects.vm
    den.aspects.containers
    den.aspects.periferics
  ];

  den.aspects.tux.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ ddcutil discord obs-studio ];
    environment.sessionVariables = {
      ACO_COMPILER = "aco";
      QSG_RHI_BACKEND = "vulkan";
    };
    services.ddccontrol.enable = true;
    services.ddccontrol.package = pkgs.ddcutil-service;
  };
}
