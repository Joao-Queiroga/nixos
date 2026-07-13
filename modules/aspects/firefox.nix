{ den, ... }: {
  den.aspects.firefox.nixos.programs.firefox = {
    enable = true;
    preferencesStatus = "default";
    languagePacks = [ "pt-BR" ];
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
}
