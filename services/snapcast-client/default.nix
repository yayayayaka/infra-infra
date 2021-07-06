{ pkgs, ... }:

{
  systemd.services.snapclient = {
    wantedBy = [ "multi-user.target" ];
    after = [ "pulseaudio.service" ];
    serviceConfig = {
      DynamicUser = true;
      RuntimeDirectory = "snapclient";
      ExecStart = "${pkgs.snapcast}/bin/snapclient -h core.lan";
    };
    environment = {
      PULSE_SERVER = "localhost";
      HOME = "/run/snapclient";
    };
  };
}
