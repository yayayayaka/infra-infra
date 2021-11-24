{ config, pkgs, ... }:

let
  ympd = pkgs.ympd.overrideAttrs (old: {
    version = "unstable-2021-05-21";
    src = pkgs.fetchFromGitHub {
      owner = "SuperBFG7";
      repo = "ympd";
      rev = "9d1a3ccfb25d011890bb90fe4ff6aaed51ffa2c4";
      sha256 = "0is2fwfmacm91yq5b22184hjyhb6i49f35dik0v3vnqkk49v565c";
    };
  });

in {

  systemd.services.ympd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${ympd}/bin/ympd --host localhost --port ${toString config.services.mpd.network.port} --webport 8062";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.default = {
      locations."/ympd/" = {
        proxyPass = "http://localhost:8062/";
        proxyWebsockets = true;
        extraConfig = ''
          allow 172.23.42.0/24;
          allow fd00::/8;
          deny all;
        '';
      };
    };
  };
}
