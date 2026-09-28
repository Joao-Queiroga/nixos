{ den, ... }: {
  den.aspects.shell = {
    nixos = { pkgs, ... }: {
      programs.bash = {
        enable = true;
        interactiveShellInit = /* sh */ ''
          if [[ $USER == root ]] && grep -qv fish /proc/$PPID/comm && [[ $SHLVL == [12] ]]; then
            SHELL=${pkgs.fish}/bin/fish exec fish
          fi
        '';
      };
      programs.fish.enable = true;
      users.defaultUserShell = pkgs.fish;
      users.users.root.shell = pkgs.bash;
      programs.zsh = {
        enable = true;
        enableCompletion = true;
      };
    };
  };
}
