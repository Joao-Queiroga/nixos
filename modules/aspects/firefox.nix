{
  den,
  inputs,
  ...
}: {
  den.aspects.firefox = {
    nixos = {
      programs.firefox = {
        enable = true;
        preferencesStatus = "default";
        languagePacks = ["pt-BR"];
        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisableFeedbackCommands = true;
          DisablePocket = true;
          DisableFirefoxSuggest = true;
          DisableFormHistory = true;
          AppAutoUpdate = false;
          BackgroundAppUpdate = false;
          OfferToSaveLogins = false;
          OfferToSaveLoginsDefault = false;
          DontCheckDefaultBrowser = true;
          DisplayMenuBar = "default-off";
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
            EmailTracking = true;
          };
          UserMessaging = {
            ExtensionRecommendations = false;
            FeatureRecommendations = false;
            SkipOnboarding = true;
            MoreFromMozilla = false;
          };
          FirefoxHome = {
            Pocket = false;
            Snippets = false;
            TopSites = false;
            SponsoredTopSites = false;
            SponsoredPocket = false;
          };
        };
      };
    };
    homeManager = {
      config,
      lib,
      ...
    }: {
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
  };
  flake-file.inputs = {
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
  };
}
