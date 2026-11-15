{
  stdenv,
  antigravity-cli,
  fetchurl,
}:

let
  version = "1.5.9";

  hashes = {
    x86_64-linux = "sha256-ix9eVnefJDSgrzbxtxWoOSoITeVQ+MaLx5gh+V+r8/o=";
    aarch64-linux = "sha256-OhjCOMfuZmHkPffoJKfUwb7Xiu7aCUMJIaDx2/6CW8o=";
    aarch64-darwin = "sha256-UfuOt+GMU9RmXwBDt2HwT00NSy6wRrrGwty+Mkc7Wy4=";
  };

  urlMap = {
    x86_64-linux = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_linux_x64.tar.gz";
    aarch64-linux = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_linux_arm64.tar.gz";
    aarch64-darwin = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_mac_arm64.tar.gz";
  };
in
antigravity-cli.overrideAttrs (_old: {
  inherit version;
  src = fetchurl {
    url = urlMap.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    hash = hashes.${stdenv.hostPlatform.system} or (throw "Missing hash for system: ${stdenv.hostPlatform.system}");
  };
})
