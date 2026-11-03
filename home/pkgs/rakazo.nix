{ lib, fetchurl, appimageTools }:

let
  pname = "rakazo";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/elie222/rakazo/releases/download/v${version}/Rakazo-${version}.AppImage";
    hash = "sha256-DePccd1pNYz7U2yCxYbqxKrHYFF+9AI+I7z4WG3ZUbg=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/rakazo.desktop $out/share/applications/rakazo.desktop
    cp -r ${appimageContents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/rakazo.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=rakazo --no-sandbox %U' \
      --replace-fail 'Categories=Utility;' 'Categories=Utility;Development;'
  '';

  meta = with lib; {
    description = "Rakazo desktop client — talks to a local or remote Rakazo API (onboarding can start the stack on this machine via Docker)";
    homepage = "https://rakazo.com/";
    changelog = "https://github.com/elie222/rakazo/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "rakazo";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
