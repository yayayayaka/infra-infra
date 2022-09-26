{ config, pkgs, ... }:

{
  services.influxdb2 = {
    enable = true;
  };
}
