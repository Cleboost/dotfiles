{ inputs, lib, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options.flake.mod = lib.mkOption {
    type = lib.types.attrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
    default = { };
  };

  config = {
    systems = [ "x86_64-linux" ];
  };
}
