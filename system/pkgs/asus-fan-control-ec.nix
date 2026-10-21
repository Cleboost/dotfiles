# ASUS EC fan control CLI (Noctalia plugin on cleboost-sage).
{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "asus-fan-control-ec";
  version = "master";

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "asus-fan-control-ec";
    rev = "master";
    sha256 = "0bmcnbpsj5zir3g2y6xb723bzv49bpp7hvgysivahfrxb3zi2ahg";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 asus-fan-control-ec $out/bin/asus-fan-control-ec
    runHook postInstall
  '';

  meta = {
    description = "ASUS embedded controller fan control";
    homepage = "https://github.com/Keyitdev/asus-fan-control-ec";
    license = lib.licenses.mit;
  };
}
