# Firmware for AIC8800 USB Wi-Fi (e.g. UGREEN AX900). Vendor blobs — unfree.
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aic8800-firmware";
  version = "5.0+git20261020";

  src = fetchFromGitHub {
    owner = "radxa-pkg";
    repo = "aic8800";
    rev = "fce88024ed40279def034e203128e0892fdbcac3";
    hash = "sha256-yJZkesIC5dppsigjFDQe2//6OqsnJ0HPrnHfwTk5bbY=";
  };

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
})
