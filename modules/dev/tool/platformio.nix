{ ... }: {
  flake.modules.nixos.dev-tool = { pkgs, ... }: {
    services.udev.packages = [ pkgs.platformio-core.udev ];
    hm.home.packages = [ pkgs.platformio ];
  };
}
