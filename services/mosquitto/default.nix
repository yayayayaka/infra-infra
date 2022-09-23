{ config, pkgs, ... }:

{
  services.mosquitto = {
    enable = true;
    listeners = [ {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
    } ];
  };

  # TODO: is this needed at all?
  networking.firewall.allowedTCPPorts = [ 1883 ];
  networking.firewall.allowedUDPPorts = [ 1883 ];
}
