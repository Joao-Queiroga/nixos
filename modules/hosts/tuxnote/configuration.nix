{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.tuxnote = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.tuxModule
    ];
  };
  flake.nixosModules.tuxnoteModule = {...}: {
    networking.hostName = "tuxnote";
    services.tlp.enable = true;
    services.upower.enable = true;
  };
}
