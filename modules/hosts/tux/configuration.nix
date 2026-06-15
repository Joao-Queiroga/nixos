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
  flake.nixosModules.tuxModule = {pkgs, ...}: {
    networking.hostName = "tux";
    imports = [
      self.nixosModules.common
      self.nixosModules.gaming
      self.nixosModules.vm
      self.nixosModules.periferics
      self.nixosModules.container
    ];
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
  };
}
