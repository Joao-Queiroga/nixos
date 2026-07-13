{ den, ... }: {
  den.aspects.vm.nixos = {
    programs.virt-manager.enable = true;
    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
