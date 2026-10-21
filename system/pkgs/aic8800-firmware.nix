# Firmware for AIC8800 USB Wi-Fi (e.g. UGREEN AX900). Vendor blobs — unfree.
{ lib, stdenvNoCC, aic8800-src }:

stdenvNoCC.mkDerivation {
  pname = "aic8800-firmware";
  version = aic8800-src.version;
  src = aic8800-src;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/firmware/aic8800_fw/USB
    cp -rv src/USB/driver_fw/fw/* $out/lib/firmware/aic8800_fw/USB/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/radxa-pkg/aic8800";
    description = "Firmware for Aicsemi AIC8800 Wi-Fi";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
