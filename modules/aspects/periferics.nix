{ den, ... }: {
  den.aspects.periferics.nixos.services.udev.extraRules = ''
    KERNEL=="hidraw*", MODE="0666", TAG+="uaccess"
  '';
}
