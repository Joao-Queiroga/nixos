{
  den,
  inputs,
  ...
}: {
  den.aspects.comma.nixos = {
    imports = [inputs.nix-index-database.nixosModules.default];
    programs.nix-index-database.comma.enable = true;
  };
  flake-file.inputs = {
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
}
