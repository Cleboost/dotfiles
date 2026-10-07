# ──────────────────────────────────────────────────────────────────────────────
# home/modules/common — shell, secrets (all hosts using this home tree)
# ──────────────────────────────────────────────────────────────────────────────
{
  imports = [
    ./shell
    ./secrets.nix
  ];
}
