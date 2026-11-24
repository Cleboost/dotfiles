{ ... }: {
  flake.modules.nixos.dev-ia = { ... }: {
    hm = { config, lib, pkgs, ... }: {
      home.packages = with pkgs; [
        (callPackage ../../../pkgs/antigravity-cli.nix { inherit antigravity-cli; })
        antigravity-hub
      ];

      home.activation.antigravityCliSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        settings="${config.home.homeDirectory}/.gemini/antigravity-cli/settings.json"
        if [ ! -e "$settings" ]; then
          $DRY_RUN_CMD mkdir -p "$(dirname "$settings")"
          $DRY_RUN_CMD ${pkgs.jq}/bin/jq -n \
            --arg home "${config.home.homeDirectory}" \
            '{
              model: "Gemini 4 Hydrogen (Low)",
              toolPermission: "always-proceed",
              trustedWorkspaces: [ $home, ($home + "/dotfiles") ]
            }' > "$settings"
        fi
      '';
    };
  };
}
