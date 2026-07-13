{ den, lib, ... }: {
  den.aspects.zram.nixos = lib.mkDefault {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      priority = 100;
    };
  };
}
