# Pinned radxa-pkg/aic8800 source with debian kernel-compat patches applied.
{ lib, stdenvNoCC, fetchFromGitHub }:

let
  version = "5.0+git20261020";
  patchesDir = ./aic8800-patches;
in
stdenvNoCC.mkDerivation {
  pname = "aic8800-src";
  inherit version;

  src = fetchFromGitHub {
    owner = "radxa-pkg";
    repo = "aic8800";
    rev = "fce88024ed40279def034e203128e0892fdbcac3";
    hash = "sha256-yJZkesIC5dppsigjFDQe2//6OqsnJ0HPrnHfwTk5bbY=";
  };

  patches = [
    "${patchesDir}/fix-vmalloc-not-include.patch"
    "${patchesDir}/fix-usb-build.patch"
    "${patchesDir}/fix-linux-6.19-build.patch"
    "${patchesDir}/fix-linux-7.0-build.patch"
    "${patchesDir}/fix-linux-7.1-build.patch"
    "${patchesDir}/fix-linux-7.2-build.patch"
    "${patchesDir}/fix-sprintf-fw-path-overlap.patch"
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Patched AIC8800 driver and firmware source tree";
    license = lib.licenses.gpl2Only;
  };
}
