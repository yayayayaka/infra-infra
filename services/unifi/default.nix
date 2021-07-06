{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  services.unifi.enable = true;
  services.unifi.unifiPackage = pkgs.unifi;

  # start controller on demand
  systemd.services.unifi.wantedBy = lib.mkForce [];

  # to access the controller ui:
  # $ ssh core.lan "sudo systemctl start unifi" 
  # $ ssh -fNL 127.0.0.1:8443:127.0.0.1:8443 core.lan
  # $ xdg-open https://127.0.0.1:8443

  # when you're done:
  # $ ssh core.lan "sudo systemctl stop unifi" 
}
