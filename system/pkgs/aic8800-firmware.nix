# Firmware for AIC8800 USB Wi-Fi (e.g. UGREEN AX900). Vendor blobs — unfree.
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aic8800-firmware";
  version = "4.0+git20250410-unstable";

  src = fetchFromGitHub {
    owner = "deepin-community";
    repo = "aic8800";
    # linux 6.19+ fixes (radxa-pkg/aic8800#69)
    rev = "2faeb57f624f87413e176e4834c6662cf5086f3c";
    hash = "sha256-KckJo0883cc2SRhuJYEU5CZ3ffR6G67z54G2LuuvIz4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/firmware/aic8800_fw/
    cp -rv firmware/* $out/lib/firmware/aic8800_fw/
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/deepin-community/aic8800";
    description = "Firmware for Aicsemi AIC8800 Wi-Fi";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
})
