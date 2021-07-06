{ pkgs, config, ... }:

let
  snapweb = pkgs.callPackage (
    { stdenv, fetchFromGitHub, nodePackages }:

    stdenv.mkDerivation rec {
      pname = "snapweb";
      version = "0.2.0";

      src = fetchFromGitHub {
        owner = "badaix";
        repo = pname;
        rev = "v${version}";
        sha256 = "1l61hy25gl6mp94jnzcb62w9av3750ipsydlm1qjzxx5nnx36rry";
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
      };
      locations."~ ^/(jsonrpc|stream)$" = {
        proxyPass = "http://localhost:${toString config.services.snapserver.http.port}";
        proxyWebsockets = true;
      };
    };
  };
}
