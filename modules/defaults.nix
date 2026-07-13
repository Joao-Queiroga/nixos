{
  lib,
  den,
  ...
}: {
  den.default = {
    nixos.system.stateVersion = "25.11";
    homeManager.home.stateVersion = "25.11";

    includes = [
      den.batteries.define-user
      den.batteries.inputs'
      den.batteries.self'
    ];
  };

  den.schema.user.classes = lib.mkDefault ["homeManager"];
}
