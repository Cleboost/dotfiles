# Firmware for AIC8800 USB Wi-Fi (e.g. UGREEN AX900).
# For MCU1 chips (chip_mcu_id=1, chip_id=7), the firmware must come from the
# legacy-mcu1 branch (shenmintao/aic8800d80@legacy-mcu1) to fit in hardware SRAM
# without crashing at 0x170400.
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "aic8800-firmware";
  version = "legacy-mcu1-20261020";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "c18136021c26800aca10ccb199c244866e1fbd6b";
    hash = "sha256-qmEHYIvKe83+BtRiQKnJIbXDFluxOp1Pi+gkIxFLR2A=";
  };

  dontBuild = true;

  # NixOS's udev module automatically compresses firmware with zstd unless disabled.
  # The out-of-tree aic8800 driver uses direct filp_open() via VFS rather than the
  # kernel request_firmware() API, so it requires raw uncompressed .bin files.
  passthru.compressFirmware = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/firmware
    cp -rv fw/* $out/lib/firmware/

    # Also keep the nested path under aic8800_fw/USB as symlinks in case anything expects it
    mkdir -p $out/lib/firmware/aic8800_fw/USB
    for dir in fw/*; do
      base="$(basename "$dir")"
      ln -s "$out/lib/firmware/$base" "$out/lib/firmware/aic8800_fw/USB/$base"
    done
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/shenmintao/aic8800d80";
    description = "Firmware for Aicsemi AIC8800 Wi-Fi (MCU1 legacy)";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
