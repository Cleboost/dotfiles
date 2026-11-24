{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { lib, ... }: {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
      };
    };
    networking.firewall.allowedTCPPorts = [ 22 ];

    hm.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*".IdentityAgent = "~/.bitwarden-ssh-agent.sock";
    };
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
