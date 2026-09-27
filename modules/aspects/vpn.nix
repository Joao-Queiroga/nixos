{ den, inputs, ... }: {
  den.aspects.vpn = {
    nixos = {
      services.mullvad-vpn = {
        enable = true;
        gui.enable = true;
        enableEarlyBootBlocking = true;
      };
    };
  };
}
