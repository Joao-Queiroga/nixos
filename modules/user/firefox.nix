{ den, inputs, ... }: {
  den.aspects.firefox-profile.homeManager = { config, lib, ... }: {
    programs.firefox = {
      enable = true;
      package = lib.mkDefault null;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles.default = {
        preConfig = builtins.readFile "${inputs.betterfox}/user.js";
        settings = {
          "browser.cache.jsbc_compression_level" = 3;
          "network.ssl_tokens_cache_capacity" = 10240;
          "network.dnsCacheEntries" = 10000;
          "network.dnsCacheExpiration" = 3600;
          "browser.cache.memory.capacity" = 131072;
          "browser.tabs.min_inactive_duration_before_unload" = 300000;
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
          "mousewheel.default.delta_multiplier_y" = 300;
          "browser.tabs.closeWindowWithLastTab" = false;
        };
      };
    };
  };
}
