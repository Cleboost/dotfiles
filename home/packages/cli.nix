# ──────────────────────────────────────────────────────────────────────────────
# home/packages/cli.nix — CLI utilities and system tools
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gh
    nvd
    nixpkgs-review
    nix-output-monitor
    ripgrep
    fd
    jq
    fastfetch
    socat
    netcat-openbsd
    age
    p7zip
    unzip
    rsync
  ];
}
