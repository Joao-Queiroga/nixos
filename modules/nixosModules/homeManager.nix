{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.myHome = {pkgs, ...}: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.joaoqueiroga = self.homeModules.main;
  };
}
