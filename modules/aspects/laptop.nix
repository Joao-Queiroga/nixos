{den, ...}: {
  den.aspects.laptop = {
    includes = [den.aspects.common];

    nixos = {
      services.tlp.enable = true;
      services.upower.enable = true;
    };
  };
}
