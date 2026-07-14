{ den, inputs, ... }: {
  den.aspects.autoupgrade.nixos = {
    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = builtins.concatLists (map (name: [ "--update-input" name ]) (builtins.attrNames inputs));
      dates = "2:00";
      randomizedDelaySec = "45min";
    };
  };
}
