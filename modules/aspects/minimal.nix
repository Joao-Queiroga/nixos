{den, ...}: {
  den.aspects.minimal = {
    includes = [
      den.batteries.hostname
      den.aspects.boot
      den.aspects.networking
      den.aspects.locale
      den.aspects.shell
      den.aspects.nix-settings
    ];
  };
}
