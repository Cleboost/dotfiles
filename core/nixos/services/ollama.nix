{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.cleboost.ollama {
  services.ollama = {
    enable = true;
    package = if config.drivers.nvidia.enable then pkgs.ollama-cuda else pkgs.ollama;
  };
}
