{ pkgs, ... }:

{
  users.users.spacekookie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBdIsXiaE3YLuqekTg8Xq65n1GUX5IQc8/FKMrbCsCWY" # tempest
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBALMtai+K3wBvpSf9ntuBH1GNte7quhIA4/ZWKlvF0A" # uwu
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICPQ7alBckvMjRL/Tp38dSkZDTR/cLHRcJPwhP5+/fdM" # qq
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
