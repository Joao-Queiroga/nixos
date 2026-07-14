{ den, inputs, ... }: {
  den.aspects.system-base.nixos = { config, pkgs, ... }: {
    imports = [ inputs.self.nixosModules.niri ];
    nixpkgs.config = { allowUnfree = true; allowBroken = true; permittedInsecurePackages = [ "ventoy-gtk3-1.1.12" ]; };
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        use-xdg-base-directories = true;
        trusted-users = [ "root" "@wheel" ];
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };
      optimise.automatic = true;
    };
    programs = {
      appimage = { enable = true; binfmt = true; }; fuse.userAllowOther = true;
      chromium.enable = true; droidcam.enable = true; kdeconnect.enable = true;
      thunar.enable = true; java.enable = true;
    };
    services = { udisks2.enable = true; gvfs.enable = true; geoclue2.enable = true; };
    environment = { pathsToLink = [ "/share/hypr" ]; binsh = "${pkgs.dash}/bin/dash"; };
  };
}
