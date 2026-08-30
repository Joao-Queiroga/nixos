{den, ...}: {
  den.aspects.desktop-base.nixos = {pkgs, ...}: {
    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };
      fuse.userAllowOther = true;
      chromium.enable = true;
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
}
