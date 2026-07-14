{ den, inputs, ... }: {
  den.aspects.hyprland.nixos = { pkgs, ... }: {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
}
