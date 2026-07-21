{
  den,
  inputs,
  ...
}: let
  caches = {
    extra-substituters = ["https://noctalia.cachix.org" "https://install.determinate.systems"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="];
  };
in {
  den.aspects.system-base.nixos = {
    config,
    pkgs,
    inputs',
    ...
  }: {
    imports = [inputs.self.nixosModules.niri];
    nix.package = inputs'.determinate.packages.default;
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = true;
      permittedInsecurePackages = ["ventoy-gtk3-1.1.12"];
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
    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };
      fuse.userAllowOther = true;
      chromium.enable = true;
      droidcam.enable = true;
      kdeconnect.enable = true;
      thunar.enable = true;
      java.enable = true;
    };
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
      geoclue2.enable = true;
    };
    environment = {
      pathsToLink = ["/share/hypr"];
      binsh = "${pkgs.dash}/bin/dash";
    };
  };
  flake-file = {
    nixConfig = caches;
    inputs = {
      determinate.url = "https://flakehub.com/f/DeterminateSystems/nix-src/*";
    };
  };
}
