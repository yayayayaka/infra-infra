{ ... }:

{
  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  services.bind = {
    enable = true;
    zones = [
      {
        name = "afra-berlin.eu.";
        master = true;
        slaves = [
          "any"                    # allow AXFR from everywhere
          "2a0f:4ac0:0:1::ec3"     # ns1.yuka.dev.
          "2a03:4000:42:6eb::1"    # ns2.yuka.dev.
        ];
        file = ./afra-berlin.eu.zone;
      }
    ];
  };

  networking.resolvconf.useLocalResolver = false;
}
