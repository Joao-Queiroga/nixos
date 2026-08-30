{
  den,
  ...
}: {
  den.aspects.tuxnote-minimal.includes = [
    den.aspects.minimal
    den.aspects.tuxnote-hardware
  ];

  den.aspects.tuxnote-minimal.nixos = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      btrfs-progs
      curl
      fish
      git
      pciutils
      util-linux
      vim
      wget
      usbutils
    ];

    nix.settings = {
      max-jobs = 1;
      cores = 1;
    };

    programs.fish.enable = true;
    users.users.root.shell = pkgs.fish;
  };
}
