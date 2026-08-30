{ den, ... }: {
  den.aspects.bluetooth = {
    nixos = { hardware.bluetooth.enable = true; services.blueman.enable = true; };
    provides.to-users = {user, ...}: {
      homeManager.services.blueman-applet.enable = true;
    };
  };
}
