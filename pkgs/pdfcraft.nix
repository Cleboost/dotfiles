{ lib, fetchurl, appimageTools }:

let
  pname = "pdfcraft";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/storytold/pdfcraft/releases/download/v${version}/pdfcraft-${version}-linux-x86_64.AppImage";
    hash = "sha256-a4k5fsEK1QXnMvGJgratFxqrCF2TjKDDA0oA1BmeOPc=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/ai.storyteller.pdfcraft.desktop $out/share/applications/ai.storyteller.pdfcraft.desktop
    cp -r ${appimageContents}/usr/share/icons $out/share/
  '';

  meta = with lib; {
    description = "Read, organize, combine, split and secure PDFs";
    homepage = "https://github.com/storytold/pdfcraft";
    license = with licenses; [ asl20 mit ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "pdfcraft";
  };
}
