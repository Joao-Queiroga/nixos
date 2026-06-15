{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.container = {pkgs, ...}: {
    virtualisation.podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
    };
  };
}
