{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../services/pulseaudio
    ../../services/snapcast-server
    ../../services/mpd
    ../../services/nfs-server
    ../../services/bgp-tunnel
    ../../services/unifi
  ];

  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5000c50038ba4de7";

  networking.interfaces.enp3s0.useDHCP = true;

  fileSystems."/mnt" =
    { device = "tank";
      fsType = "zfs";
      options = ["nofail"];
    };

  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "bdd1349f";

  #services.samba = {
  #  package = pkgs.sambaFull;
  #  enable = true;
  #  securityType = "user";
  #  extraConfig = ''
  #    hosts allow = 172.23.42.0 localhost
  #    hosts deny = 0.0.0.0/0
  #  '';
  #  shares = {
  #    storage = {
  #      path = "/data";
  #      browseable = "yes";
  #      "read only" = "no";
  #      "guest ok" = "yes";
  #      "create mask" = "0644";
  #      "directory mask" = "0755";
  #    };
  #  };
  #};

  system.stateVersion = "21.05";
}

# wireguard pubkey: ImxmLMTnlFiEehfA0j/WMfYhKle8XpOKrIPDAd+y3SA=
