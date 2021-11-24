{ pkgs, config, ... }:

let
  snapweb = pkgs.callPackage (
    { stdenv, fetchFromGitHub, nodePackages }:

    stdenv.mkDerivation rec {
      pname = "snapweb";
      version = "latest";

      src = fetchFromGitHub {
        owner = "badaix";
        repo = pname;
        rev = "ccfa454e9ff32f0443b425ee8ae1b0c25158f200";
        sha256 = "sha256-wScOUiIKhNkfwReLxPSNs9BsXjvCbhM1Lr84w8ynWVU=";
      };

      nativeBuildInputs = [ nodePackages.typescript ];

      installPhase = ''
        runHook preInstall
        cp -r dist $out
        runHook postInstall
      '';
    }
  ) {};

in {
  services.snapserver = {
    streams.default.location = "/run/snapserver/default";
    enable = true;
    openFirewall = true;
  };

  hardware.pulseaudio.extraConfig = ''
    load-module module-pipe-sink file=${config.services.snapserver.streams.default.location} sink_name=Snapcast format=s16le rate=48000
    update-sink-proplist Snapcast device.description=Snapcast
  '';

  services.nginx = {
    enable = true;
    virtualHosts.default = {
      locations."/snapweb/" = {
        alias = "${snapweb}/";
        extraConfig = ''
          allow 172.23.42.0/24;
          allow fd00::/8;
          deny all;
        '';
      };
      locations."~ ^/(jsonrpc|stream)$" = {
        proxyPass = "http://localhost:${toString config.services.snapserver.http.port}";
        proxyWebsockets = true;
      };
    };
  };
}
