# Vendored from nixpkgs PR #580999 until merged upstream.
{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  jdk25,
  openssl,
  alsa-lib,
  systemd,
  fontconfig,
  freetype,
  libGL,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "horizon-launcher";
  version = "0.2.36";

  __structuredAttrs = true;

  env = {
    HORIZON_LAUNCHER_VERSION = finalAttrs.version;
    HORIZON_LAUNCHER_TAG = "launcher@${finalAttrs.version}";
    HORIZON_MSA_CLIENT_ID = "331e08f8-172d-43b9-835a-3108c2fcdbf3";
  };

  src = fetchFromGitHub {
    owner = "horizon-rust";
    repo = "horizon";
    tag = "launcher@${finalAttrs.version}";
    hash = "sha256-RcstuW4C3qnl2iA8WJ5qGRnBMwN3HpNfuDANX8n7c9U=";
  };

  cargoRoot = "launcher";
  buildAndTestSubdir = "launcher";

  cargoHash = "sha256-ZfDVuvv/ZJq5Q8C/dw1YOvmdO2Gpv2AQqn0Le6iDaUk=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    systemd
    fontconfig
    freetype
    libGL
    libxcb
    libxkbcommon
    openssl
    vulkan-loader
    wayland
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/horizon-launcher $out/bin/horizon-launcher

    wrapProgram $out/bin/horizon-launcher \
      --set-default HORIZON_TELEMETRY_URL off \
      --prefix PATH : ${lib.makeBinPath [ jdk25 ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/horizon-launcher --version
    runHook postInstallCheck
  '';

  passthru.upstreamTag = finalAttrs.src.tag;

  meta = with lib; {
    description = "Launcher for Horizon, an unofficial native Minecraft: Java Edition 26.3 client";
    homepage = "https://playhorizon.dev";
    license = licenses.mit;
    mainProgram = "horizon-launcher";
    platforms = rustc.meta.platforms;
  };
})
