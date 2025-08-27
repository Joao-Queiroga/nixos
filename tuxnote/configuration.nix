{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  services.tlp = { enable = true; };
}
