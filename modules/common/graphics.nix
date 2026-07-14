{ den, ... }: {
  den.aspects.graphics.nixos = { pkgs, ... }: {
    hardware.graphics = { enable = true; enable32Bit = true; extraPackages = with pkgs; [ mesa vulkan-tools ]; };
  };
}
