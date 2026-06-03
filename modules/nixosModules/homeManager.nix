{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.myHome = {pkgs, ...}: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.joaoqueiroga = self.homeModules.main;
      backupFileExtension = "bkp";
      overwriteBackup = true;
    };
  };
}
