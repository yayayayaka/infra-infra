{ config, pkgs, ... }:

{
  services.grafana = {
    enable = true;
    # Listening address and TCP port
    addr = "127.0.0.1";
    port = 3072;
    # Grafana needs to know on which domain and URL it's running:
    domain = "grafana.afra-berlin.eu";
    rootUrl = "https://grafana.afra-berlin.eu/"; # Not needed if it is `https://your.domain/`
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      # TODO: Add to the documentation
      # "core.afra-berlin.eu".locations."/ympd/".return = "307 https://ympd.afra-berlin.eu";
      "grafana.afra-berlin.eu" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:3072/";
          proxyWebsockets = true;
          # TODO: do we want it in the public internet?
          # extraConfig = ''
          #   allow 172.23.42.0/24;
          #   allow fd00::/8;
          #   deny all;
          # '';
        };
      };
    };
  };
}
