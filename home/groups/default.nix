{
  imports = [
    ./base-shell
    ./base-apps
    ./dev
    ./gui
    ./social
    ./media
    ./other
    ./gaming
  ];

  # Single MIME module; groups only add defaultApplications entries
  xdg.mimeApps.enable = true;
}
