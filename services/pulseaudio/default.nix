{ pkgs, ... }:

{
  networking.firewall.interfaces.enp3s0.allowedTCPPorts = [ 4713 ];
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.systemWide = true;
  hardware.pulseaudio.package = pkgs.pulseaudio;
  hardware.pulseaudio.tcp.enable = true;
  hardware.pulseaudio.tcp.anonymousClients.allowedIpRanges = [ "fe80::/64" "127.0.0.0/8" "::/64" "fd00::/8" "172.23.42.0/24" ];
  environment.variables.PULSE_SERVER = "localhost";
}
