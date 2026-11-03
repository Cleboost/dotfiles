# Clé USB — barre simple, pas de widgets bureau perso brain/sage.
{ base, ... }:

base // {
  bar = base.bar // {
    main = base.bar.main // {
      center = [
        "media"
      ];
    };
  };

  desktop_widgets = base.desktop_widgets // {
    enabled = false;
  };
}
