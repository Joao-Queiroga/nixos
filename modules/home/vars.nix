{inputs, ...}: {
  flake.homeModules.vars = {
    pkgs,
    config,
    ...
  }: {
    home.sessionPath = [
      "${config.home.sessionVariables.CARGO_HOME}/bin"
      "${config.home.sessionVariables.GOPATH}/bin"
      "${config.xdg.binHome}"
    ];

    xdg.enable = true;

    home.sessionVariables = {
      EDITOR = "nvim";
      PF_INFO = "ascii title os host kernel uptime pkgs wm memory palette";

      MESA_SHADER_CACHE_DIR = "${config.home.homeDirectory}/.cache/mesa_shader_cache";
      MESA_SHADER_CACHE_MAX_SIZE = "12G";
      RADV_PERFTEST = "aco";
      NIXOS_OZONE_WL = "1";
      XINITRC = "${config.xdg.configHome}/x11/xinitrc";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
      GOPATH = "${config.xdg.dataHome}/go";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      WGETRC = "${config.xdg.configHome}/wget/wgetrc";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      ANDROID_SDK_HOME = "${config.xdg.configHome}/android";
      ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
      BUN_INSTALL = "${config.xdg.dataHome}/bun";
      NPM_CONFIG_INIT_MODULE = "${config.xdg.configHome}/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      WINEPREFIX = "${config.xdg.dataHome}/wine";

      CARAPACE_HIDDEN = 1;
      CARAPACE_LENIENT = 1;
      CARAPACE_MATCH = 1;

      W3M_DIR = "${config.xdg.configHome}/w3m";

      MANPAGER = "nvim +Man!";
    };

    xdg.terminal-exec = {
      enable = true;
      settings = {default = ["kitty.desktop"];};
    };

    xdg.configFile."w3m/config".text = "inline_img_protocol 4";
  };
}
