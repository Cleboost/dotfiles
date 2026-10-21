# Out-of-tree kernel modules for AIC8800 USB (UGREEN AX900, etc.).
{
  lib,
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  aic8800-src,
}:

let
  driverDir = "src/USB/driver_fw/drivers/aic8800";
in
stdenv.mkDerivation {
  pname = "aic8800";
  version = aic8800-src.version;
  src = aic8800-src;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  buildPhase = ''
    runHook preBuild
    make -C ${driverDir} $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    directory="lib/modules/${kernel.modDirVersion}/kernel/drivers/aic8800_USB"
    mkdir -p "$out/$directory"
    install -Dm444 -t "$out/$directory" \
      ${driverDir}/aic_load_fw/aic_load_fw.ko \
      ${driverDir}/aic8800_fdrv/aic8800_fdrv.ko
    # nixpkgs #571181: linux-modules merge expects a .ko.cer next to each extra .ko.
    for ko in "$out/$directory"/*.ko; do
      : > "$ko.cer"
    done
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/radxa-pkg/aic8800";
    description = "Aicsemi AIC8800 USB Wi-Fi driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
