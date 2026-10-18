{
  lib,
  stdenv,
  antigravity-cli,
  fetchurl,
}:

let
  version = "1.4.2";
  buildId = "4835981233356800";
  wholeVersion = "${version}-${buildId}";

  hashes = {
    x86_64-linux = "sha256-Y5WDesDhk90/5Q8SKOHErqNFypljbVRASrfnQ5fUCRw=";
    aarch64-linux = "sha256-CN1KLKUtUx/vHfrk7C+6/NVjQr+mlMgZOmDaKyb7GJg=";
    aarch64-darwin = "sha256-T+0kdNoxTxCc9QXxMl64QwevzVhiQua2kfB0/Rpz5qo=";
  };

  urlMap = {
    x86_64-linux = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${wholeVersion}/linux-x64/cli_linux_x64.tar.gz";
    aarch64-linux = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${wholeVersion}/linux-arm/cli_linux_arm64.tar.gz";
    aarch64-darwin = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${wholeVersion}/darwin-arm/cli_mac_arm64.tar.gz";
  };
in
antigravity-cli.overrideAttrs (old: {
  inherit version;
  src = fetchurl {
    url = urlMap.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Missing hash for system: ${stdenv.hostPlatform.system}");
  };

  passthru = (old.passthru or { }) // {
    inherit wholeVersion;
  };
})
