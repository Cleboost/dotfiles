{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "gaming" config.cleboost.groups) {
  home.packages = with pkgs; [
    prismlauncher
    beammp-launcher
    mindustry-wayland
    gamescope
    protontricks
    vkbasalt
  ];

  programs.mangohud = {
    enable = true;
    enableSessionWide = false;
    settings = {
      fps = true;
      fps_metrics = "avg,0.01";
      frametime = true;
      frame_timing = 1;

      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_power = true;

      cpu_stats = true;
      cpu_temp = true;
      cpu_mhz = true;

      vram = true;
      ram = true;

      position = "top-left";
      round_corners = 10;
      background_alpha = "0.6";
      font_size = 20;

      toggle_hud = "Shift_R+F12";
      toggle_hud_position = "Shift_R+F11";
      reset_fps_metrics = "Shift_R+F9";
    };
  };

  xdg.configFile."hypr/autostart/gaming.lua".source = ./hypr-autostart.lua;
}
