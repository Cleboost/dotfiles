{ ... }: {
  flake.modules.nixos.dev-ia = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ antigravity-hub ];
  };
}
