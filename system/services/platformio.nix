# PlatformIO / ESP32 USB flash & serial (pio run -t upload, device monitor).
# Without this, PIO warns about missing 99-platformio-udev.rules.
{ pkgs, ... }:

{
  services.udev.packages = [ pkgs.platformio-core.udev ];
}