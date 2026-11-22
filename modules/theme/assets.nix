{ ... }: {
  flake.modules.nixos.desktop = { ... }: {
    hm.home.file = {
      "Pictures/Wallpapers".source = ../../assets/wallpaper;
      "Pictures/profile.png".source = ../../assets/image/profile.png;
      "Pictures/banner.png".source = ../../assets/image/banner.png;
    };
  };
}
