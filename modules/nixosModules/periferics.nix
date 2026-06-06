{...}: {
  flake.nixosModules.periferics = {
    services.udev.extraRules = ''
      KERNEL=="hidraw*", MODE="0666", TAG+="uaccess"
    '';
  };
}
