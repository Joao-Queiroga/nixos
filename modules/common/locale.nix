{ den, ... }: {
  den.aspects.locale.nixos = {
    time.timeZone = "Brazil/East";
    i18n.defaultLocale = "pt_BR.UTF-8";
    console = { font = "Lat2-Terminus16"; keyMap = "br-abnt2"; };
    services.xserver.xkb.layout = "br";
    services.xserver.xkb.options = "numlock:on";
  };
}
