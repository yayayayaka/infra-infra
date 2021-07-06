{ config, pkgs, ... }:

let
  # fix for htdocs not being found
  mympd = pkgs.mympd.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [
      "-DCMAKE_BUILD_TYPE=RELEASE"
    ];
    preBuild = ''
      pushd ..
      ./build.sh createassets
      popd
      find . -name "*.gz"
      mv ../release/htdocs .
    '';
    nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [ perl ]);
  });

  # these are only used on first start to feed defaults into the database :/
  configFile = pkgs.writeText "mympd.conf" ''
    [mpd]
    host = localhost
    port = ${toString config.services.mpd.network.port}

    [webserver]
    httphost = [::1]
    httpport = 8057
    ssl = false
  '';

in {
  systemd.services.mympd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "mympd";
      ExecStart = "${mympd}/bin/mympd ${configFile}";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.default = {
      locations."/mympd/" = {
        proxyPass = "http://localhost:8057/";
        proxyWebsockets = true;
      };
    };
  };
}
