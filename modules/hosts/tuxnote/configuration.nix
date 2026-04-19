{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.tuxnote = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.tuxnoteModule
    ];
  };
  flake.nixosModules.tuxnoteModule = {...}: {
    imports = [
      self.nixosModules.common
    ];
    networking.hostName = "tuxnote";
    services.tlp.enable = true;
    services.upower.enable = true;
  };
}
