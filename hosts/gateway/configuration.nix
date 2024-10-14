{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.enp1s0.useDHCP = true;

  system.stateVersion = "24.11";
}
