# Live / invité — barre simple, pas de widgets bureau ni plugins perso.
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
