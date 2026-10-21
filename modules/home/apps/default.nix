{
  imports = [
    ./base-shell
    ./base-apps
    ./dev
    ./ia
    ./gui
    ./social
    ./social/zapfast
    ./media
    ./other
    ./gaming
  ];

  # Single MIME module; groups only add defaultApplications entries
  xdg.mimeApps.enable = true;
}
