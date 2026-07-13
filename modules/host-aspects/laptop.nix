{den, ...}: {
  den.aspects.tuxnote.includes = [
    den.aspects.common
    den.aspects.tuxnote-hardware
  ];

  den.aspects.tuxnote.nixos = {
    services.tlp.enable = true;
    services.upower.enable = true;
  };
}
