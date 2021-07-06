# build an sd image with:
# ~/infra-infra$ nix-build -A hosts.musicpi.config.system.build.sdImage

{ lib, pkgs, config, modulesPath, ... }:

{
  imports = [
    ../../common
    ../../services/pulseaudio
    ../../services/snapcast-client
    ../../services/mpd
    ../../services/nfs-client
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  deploy.ssh.host = "musicpi2.lan";

  boot.supportedFilesystems = lib.mkForce [ "ext4" "vfat" "nfs" ];

  nixpkgs.system = "aarch64-linux";

  boot.initrd.availableKernelModules = lib.mkForce [ "vc4" "i2c_bcm2835" ];
  boot.kernelPackages = pkgs.linuxPackages_rpi3;

  hardware.deviceTree.filter = "bcm*-rpi-3-b-plus.dtb";
  hardware.deviceTree.raspberryPi.enable = true;
  hardware.deviceTree.raspberryPi.params.spi = "on";
  hardware.deviceTree.raspberryPi.overlays = [ "${config.boot.kernelPackages.kernel}/dtbs/overlays/hifiberry-dacplus.dtbo" ];

  networking = {
    useNetworkd = lib.mkForce false;
    useDHCP = lib.mkForce true;
  };

  documentation.enable = false;

  system.stateVersion = "21.05";
}
