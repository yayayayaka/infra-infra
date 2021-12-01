# build an sd image with:
# ~/infra-infra$ nix-build -A hosts.musicpi.config.system.build.sdImage

{ lib, pkgs, config, modulesPath, ... }:

{
  imports = [
    ../../common
    ../../services/pulseaudio
    ../../services/snapcast-client
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  # We import sd-image-aarch64.nix so we can build a config.system.build.sdImage
  # But it imports some modules we don't want, so disable them
  disabledModules = [
    "profiles/base.nix"
    "profiles/all-hardware.nix"
  ];
  boot.initrd.availableKernelModules = [ "mmc_block" "usbhid" "usb_storage" "vc4" ];
  boot.initrd.includeDefaultModules = false;

  nixpkgs.system = "aarch64-linux";
  boot.kernelPackages = pkgs.linuxPackages_rpi3;
  hardware.deviceTree.filter = "bcm*-rpi-3-b-plus.dtb";
  hardware.deviceTree.raspberryPi.enable = true;
  hardware.deviceTree.raspberryPi.params.spi = "on";
  hardware.deviceTree.raspberryPi.overlays = [ "${config.boot.kernelPackages.kernel}/dtbs/overlays/hifiberry-amp.dtbo" ];

  networking = {
    useNetworkd = lib.mkForce false;
    useDHCP = lib.mkForce true;
  };

  boot.tmpOnTmpfs = true; # building stuff on sd-card is slow

  system.stateVersion = "21.05";
}
