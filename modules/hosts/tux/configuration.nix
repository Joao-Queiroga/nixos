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

    service.ddccontrol.enable = true;
  };
}
