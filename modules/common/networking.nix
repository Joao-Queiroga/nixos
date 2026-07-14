{ den, ... }: {
  den.aspects.networking.nixos = {
    networking.networkmanager = { enable = true; wifi.backend = "iwd"; };
    networking.firewall.checkReversePath = false;
    services.chrony = { enable = true; servers = [ "a.st1.ntp.br" "b.st1.ntp.br" "c.st1.ntp.br" "d.st1.ntp.br" ]; };
    services.timesyncd.enable = false;
  };
}
