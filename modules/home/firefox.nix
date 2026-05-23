{inputs, ...}: {
  flake.homeModules.firefox = {
    pkgs,
    lib,
    ...
  }: {
    programs.firefox = {
      enable = true;
      package = lib.mkDefault null;
      profiles = {
        default = {
          preConfig = builtins.readFile "${inputs.betterfox}/user.js";
          settings = {
            # Cache de bytecode JS — acelera recarregamentos
            "browser.cache.jsbc_compression_level" = 3;
            # TLS token cache — reconexões mais rápidas
            "network.ssl_tokens_cache_capacity" = 10240;
            # DNS cache maior
            "network.dnsCacheEntries" = 10000;
            "network.dnsCacheExpiration" = 3600;
            # RAM cache — 128MB (vale com 16GB)
            "browser.cache.memory.capacity" = 131072;
            # Descarregar abas inativas após 5min em vez de 10min
            "browser.tabs.min_inactive_duration_before_unload" = 300000;
            # Smooth scroll — msdPhysics
            "general.smoothScroll" = true;
            "general.smoothScroll.msdPhysics.enabled" = true;
            "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
            "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
            "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
            "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
            "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
            "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
            "general.smoothScroll.currentVelocityWeighting" = "1";
            "general.smoothScroll.stopDecelerationWeighting" = "1";
            # Velocidade do scroll — ajuste ao seu gosto (250-400)
            "mousewheel.default.delta_multiplier_y" = 300;

            "browser.tabs.closeWindowWithLastTab" = false;
          };
        };
      };
    };
  };
}
