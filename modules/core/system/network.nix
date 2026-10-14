{ pkgs, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall.enable = true;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = "1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com";
      FallbackDNS = "1.0.0.1 1.1.1.1";
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
    };
  };

  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
        JustWorksRepairing = "always";
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
