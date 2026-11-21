# ASUS EC fan control CLI (Noctalia plugin on cleboost-sage).
{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "asus-fan-control-ec";
  version = "master";

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "asus-fan-control-ec";
    rev = "master";
    hash = "sha256-Iu+pqRW8baqMfw3dF77b1LU7K5iFQmNedZOF0B9PIxc=";
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
