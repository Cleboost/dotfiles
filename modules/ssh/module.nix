{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      IdentityAgent = "~/.bitwarden-ssh-agent.sock";
    };
  };
}
