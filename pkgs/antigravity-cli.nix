{
  lib,
  stdenv,
  antigravity-cli,
  fetchurl,
}:

let
  version = "1.3.5";
  buildId = "6164039479459840";
  wholeVersion = "${version}-${buildId}";

  hashes = {
    x86_64-linux = "sha256-AHpaRNuvHK6kZMPZhIxjsvaZRbAai/iFLFbEd6ZDdM8=";
    aarch64-linux = "sha256-BlUFq0aG7HETt8zYf86HeVqP1Ld3b3cdpNU5QCBuNMw=";
    aarch64-darwin = "sha256-YLRnE9DnIXt5ZWD/wcPFafTgszVwdu5rYNRkgy1tQQU=";
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
