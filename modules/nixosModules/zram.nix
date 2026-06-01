{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.zram = {
    config,
    lib,
    ...
  }: {
    zramSwap = lib.mkDefault {
      enable = true;
      algorithm = "zstd";
      priority = 100;
    };
  };
}
