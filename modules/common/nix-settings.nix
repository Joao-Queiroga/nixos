{
  den,
  ...
}: let
  caches = {
    extra-substituters = ["https://noctalia.cachix.org" "https://install.determinate.systems"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="];
  };
in {
  den.aspects.nix-settings.nixos = {
    inputs',
    ...
  }: {
    nix.package = inputs'.determinate.packages.default;
    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = ["ventoy-gtk3-1.1.17"];
    };
    nix = {
      settings =
        {
          experimental-features = ["nix-command" "flakes"];
          use-xdg-base-directories = true;
          trusted-users = ["root" "@wheel"];
        }
        // caches;
      optimise.automatic = true;
    };
  };
  flake-file = {
    nixConfig = caches;
    inputs = {
      determinate.url = "https://flakehub.com/f/DeterminateSystems/nix-src/*";
    };
  };
}
