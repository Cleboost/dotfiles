{ lib, fetchurl, appimageTools }:

let
  pname = "rakazo";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/elie222/rakazo/releases/download/v${version}/Rakazo-${version}.AppImage";
    hash = "sha256-1f2iv5nmiy5w4cz05x3ya5hcgan4xa3cb0kcagxqqdb9vmqxrqqd=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    if [ -f ${appimageContents}/rakazo.desktop ]; then
      install -m 444 -D ${appimageContents}/rakazo.desktop $out/share/applications/rakazo.desktop
    elif [ -f ${appimageContents}/Rakazo.desktop ]; then
      install -m 444 -D ${appimageContents}/Rakazo.desktop $out/share/applications/rakazo.desktop
    fi

    if [ -d ${appimageContents}/usr/share/icons ]; then
      cp -r ${appimageContents}/usr/share/icons $out/share/
    fi

    if [ -f $out/share/applications/rakazo.desktop ]; then
      substituteInPlace $out/share/applications/rakazo.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=rakazo' \
        --replace-fail 'Exec=AppRun %U' 'Exec=rakazo %U' || true
    fi
  '';

  meta = with lib; {
    description = "Open-source self-hosted AI agent for persistent teammates (desktop client)";
    homepage = "https://rakazo.com/";
    changelog = "https://github.com/elie222/rakazo/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "rakazo";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
