{ config, pkgs, ... }:

{
  services.minetest-server = {
    enable = true;
    world = /var/lib/minetest/.minetest/worlds/MineforTestMine;
    gameId = "minetest";
    configPath = /var/lib/minetest/.minetest/minetest.conf;
  };

  # TODO: are both needed?
  networking.firewall.allowedTCPPorts = [ 30000 ];
  networking.firewall.allowedUDPPorts = [ 30000 ];
}
