{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.firefox = {
    pkgs,
    config,
    lib,
    ...
  }: {
    programs.firefox = {
      enable = true;
      preferencesStatus = "default";
      languagePacks = ["pt-BR"];
      policies = {
        # Telemetria e estudos
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisableFeedbackCommands = true;
        # Funcionalidades desnecessárias
        DisablePocket = true;
        DisableFirefoxSuggest = true;
        DisableFormHistory = true;
        # Updates (o Nix cuida disso)
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;
        # Senhas (usa Bitwarden)
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        # Comportamento geral
        DontCheckDefaultBrowser = true;
        DisplayMenuBar = "default-off";
        # Proteção de rastreamento
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        # Mensagens e UI desnecessária
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
        };
        # Firefox Home (nova aba)
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
}
