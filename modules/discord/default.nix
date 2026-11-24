{ ... }: {
  flake.modules.nixos.dekstop = { pkgs, ... }: {
    hm = {
      home.packages = with pkgs; [
        discord
        # vesktop
      ];

      xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "discord.desktop";
    };
  };
}
