{
  den,
  inputs,
  ...
}: {
  den.aspects.autoupgrade.nixos = {
    system.autoUpgrade = {
      enable = true;
      dates = "weekly";
      flake = inputs.self.outPath;
      flags = builtins.concatLists (map (name: ["--update-input" name]) (builtins.attrNames inputs));
      randomizedDelaySec = "45min";
    };
  };
}
