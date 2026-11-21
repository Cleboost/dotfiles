# Always-active config (shell, desktop, bar, etc.).
{
  imports = [
    ./session/module.nix
    ./shell/module.nix
    ./ssh/module.nix
    ./bitwarden/module.nix
    ./fastfetch/module.nix
    ./starship/module.nix
    ./kitty/module.nix
    ./hyprland/autostart-groups.nix
    ./hyprland/module.nix
    ./theme/module.nix
    ./wireplumber/module.nix
    ./noctalia/module.nix
    ./antigravity-hub/module.nix
  ];
}
