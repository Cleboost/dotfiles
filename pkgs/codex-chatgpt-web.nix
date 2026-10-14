{ lib, fetchurl, appimageTools }:

let
  pname = "codex-chatgpt-web";
  version = "6.1.9";

  src = fetchurl {
    url = "https://github.com/miuuyy/codex-chatgpt-web/releases/download/v${version}/codex-web-gpt-${version}-linux-x64.AppImage";
    hash = "sha256-YOmW9Lu7fNxUqjCtyv2LBYbLMjoPs8peidVqsRoXLw4=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/codex-web-gpt-launcher.desktop $out/share/applications/codex-web-gpt.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/codex-web-gpt-launcher.png \
      $out/share/icons/hicolor/1024x1024/apps/codex-web-gpt.png
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/codex-web-gpt-launcher.png \
      $out/share/icons/hicolor/512x512/apps/codex-web-gpt.png 2>/dev/null || true

    substituteInPlace $out/share/applications/codex-web-gpt.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=codex-web-gpt %U' \
      --replace-fail 'Icon=codex-web-gpt-launcher' 'Icon=codex-web-gpt'

    # Symlink binary as codex-web-gpt and codex-chatgpt-web
    ln -s $out/bin/${pname} $out/bin/codex-web-gpt
  '';

  meta = with lib; {
    description = "Focused local Responses bridge that runs Codex tasks through a user-authenticated ChatGPT web session";
    homepage = "https://github.com/miuuyy/codex-chatgpt-web";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "codex-web-gpt";
  };
}
