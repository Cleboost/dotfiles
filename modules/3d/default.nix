{ ... }: {
  flake.modules.nixos.doc3d = { pkgs, ... }: {
    hm.home.packages = with pkgs; [
      blockbench
      blender
    ];
  };
}
