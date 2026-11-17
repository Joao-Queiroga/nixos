{ den, ... }: {
  den.aspects.desktop-base.nixos = { pkgs, ... }: {
    programs = {
      appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs =
            p:
            with p;
            builtins.concatMap
              (x: [
                x
                (lib.getDev x)
              ])
              [
                sdl3
                opus
                libvpx
                dav1d
                zstd
                vulkan-headers
                vulkan-loader
              ]
            ++ [
              clang
              lld
              gcc
              binutils
              pkg-config
              libgpg-error
              libgcrypt
            ];
        };
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
      pathsToLink = [ "/share/hypr" ];
      binsh = "${pkgs.dash}/bin/dash";
    };
  };
}
