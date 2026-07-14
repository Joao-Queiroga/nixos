{ den, ... }: {
  den.aspects.kitty.homeManager.programs.kitty = {
    enable = true;
    settings = {
      cursor = "none";
      enable_audio_bell = false;
      tab_bar_style = "slant";
      confirm_os_window_close = 0;
    };
    extraConfig = "cursor none";
  };
}
