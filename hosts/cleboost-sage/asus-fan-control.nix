# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-sage/asus-fan-control.nix — ASUS EC fan control (Noctalia plugin)
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation rec {
      pname = "asus-fan-control-ec";
      version = "master";
      src = pkgs.fetchFromGitHub {
        owner = "Keyitdev";
        repo = "asus-fan-control-ec";
        rev = "master";
        sha256 = "1brfc7q09z0vvypqdzl9a9rwpm81pmwssh1djdiwx20l8nr6vxkd";
      };
      installPhase = ''
        mkdir -p $out/bin
        install -Dm755 asus-fan-control-ec $out/bin/asus-fan-control-ec
      '';
    })
  ];

  security.sudo.extraRules = [
    {
      users = [ "cleboost" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/asus-fan-control-ec";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
