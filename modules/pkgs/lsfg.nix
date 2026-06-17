{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    lsfg-vk-common = {
      version = "2.0.0-dev";
      src = inputs.lsfg-vk;
      nativeBuildInputs = with pkgs; [cmake patchelf];
      meta = {
        homepage = "https://github.com/PancakeTAS/lsfg-vk";
        license = lib.licenses.gpl3Plus;
        platforms = lib.platforms.linux;
      };
      postFixup = ''
        for f in $out/bin/* $out/lib/*.so; do
          [ -f "$f" ] && patchelf --add-rpath ${pkgs.vulkan-loader}/lib "$f"
        done
      '';
    };
  in {
    packages.lsfg-vk = pkgs.stdenv.mkDerivation (lsfg-vk-common
      // {
        pname = "lsfg-vk";
        buildInputs = with pkgs; [vulkan-headers vulkan-loader];

        cmakeFlags = [
          "-DLSFGVK_BUILD_VK_LAYER=ON"
          "-DLSFGVK_BUILD_CLI=ON"
          "-DLSFGVK_BUILD_UI=OFF"
          "-DLSFGVK_INSTALL_XDG_FILES=ON"
        ];

        meta.description = "Vulkan layer for frame generation using Lossless Scaling";
      });

    packages.lsfg-vk-ui = pkgs.stdenv.mkDerivation (lsfg-vk-common
      // {
        pname = "lsfg-vk-ui";
        nativeBuildInputs = lsfg-vk-common.nativeBuildInputs ++ (with pkgs; [qt6.wrapQtAppsHook]);
        buildInputs = with pkgs; [vulkan-headers vulkan-loader qt6.qtbase qt6.qtdeclarative];

        cmakeFlags = [
          "-DLSFGVK_BUILD_VK_LAYER=OFF"
          "-DLSFGVK_BUILD_CLI=OFF"
          "-DLSFGVK_BUILD_UI=ON"
          "-DLSFGVK_INSTALL_XDG_FILES=ON"
        ];

        meta.description = "lsfg-vk with Qt6 UI";
      });
  };
}
