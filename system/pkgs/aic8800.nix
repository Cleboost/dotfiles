# Out-of-tree kernel modules for AIC8800 USB (UGREEN AX900, etc.).
{
  lib,
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  aic8800-firmware,
}:
stdenv.mkDerivation {
  pname = "aic8800";
  version = aic8800-firmware.version;
  src = aic8800-firmware.src;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  buildPhase = ''
    make -C src/USB/aic8800 $makeFlags
  '';

  installPhase = ''
    runHook preInstall
    directory="lib/modules/${kernel.modDirVersion}/kernel/drivers/aic8800_USB"
    mkdir -p "$out/$directory"
    install -Dm444 -t "$out/$directory" \
      src/USB/aic8800/aic_load_fw/aic_load_fw.ko \
      src/USB/aic8800/aic8800_fdrv/aic8800_fdrv.ko
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/deepin-community/aic8800";
    description = "Aicsemi AIC8800 USB Wi-Fi driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
