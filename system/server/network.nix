{ ... }:

{
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    # Dokploy / Traefik bind via Docker (hors nftables classique) — 80/443 à revoir au déploiement.
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = "1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com";
      FallbackDNS = "1.0.0.1 1.1.1.1";
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
    };
  };
}
