{
  den,
  inputs,
  ...
}: {
  den.aspects.neovim.nixos = {pkgs, ...}: {
    programs.neovim = {
      enable = true;
      package = inputs.my-neovim.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
  flake-file.inputs = {
    my-neovim.url = "github:/Joao-Queiroga/nvim";
    my-neovim.inputs.nixpkgs.follows = "nixpkgs";
  };
}
