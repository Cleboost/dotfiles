{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        extraOptions = {
          IdentityAgent = "~/.bitwarden-ssh-agent.sock";
        };
      };

      # Exemple d'hôte SSH (à décommenter et adapter) :
      # "mon-serveur" = {
      #   hostname = "192.168.1.100";
      #   user = "cleboost";
      #   port = 22;
      # };
    };
  };
}
