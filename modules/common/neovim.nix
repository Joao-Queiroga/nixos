{ den, inputs, ... }: {
  den.aspects.neovim.nixos = { pkgs, ... }: {
    programs.neovim = { enable = true; package = inputs.my-neovim.packages.${pkgs.stdenv.hostPlatform.system}.default; };
  };
}
