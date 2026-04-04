{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.qylock = pkgs.stdenvNoCC.mkDerivation {
      pname = "qylock";
      version = "1.0";
      src = inputs.qylock;
      dontBuild = true;
      dontConfigure = true;
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/sddm/themes
        cp -r $src/themes/* $out/share/sddm/themes

        mkdir -p $out/share/quickshell
        cp -r $src/quickshell-lockscreen/* $out/share/quickshell/ 2>/dev/null || true

        runHook postInstall
      '';
      propagatedBuildInputs = with pkgs; [
        (with gst_all_1; [
          gst-plugins-base
          gst-plugins-good
          gst-plugins-bad
          gst-plugins-ugly
        ])
        (with kdePackages; [
          qtmultimedia
          qtsvg
          qt5compat
          qtmultimedia
        ])
        fzf
      ];
      meta = with pkgs.lib; {
        description = "Coleção de temas cozy para SDDM e Quickshell (qylock)";
        homepage = "https://github.com/Darkkal44/qylock";
        license = licenses.mit;
        platforms = platforms.linux;
      };
    };
  };
}
