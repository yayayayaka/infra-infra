{ pkgs, ... }:

{
  users.users.lux = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCgxVMnvoWG8PATLvl32JrpnR1TV47FBsd1iX14wPOxlhsYHPkkNiptJj1osvymnNUU1sh7MBGjQidA5CfM3hlr1UYmgiwqt/Xqi+u3cJ99zE2J9rmyVui2wmSla8lBtL/zZYhPWKZJzCygLOqnwGgZaFgxCwPswoRCkkx6D6tldUS9BYGtDg2zmrMEQronLuxdlEyMEAmSIVn5/H62sxqx2XT6nPbdWXNsCv4FvNJimlHiqPpeRVG3MEkco56y+RFHv5aoOyZs/jQGJSMr2vOpbAudk1KPlqBrG34kD1MNsJ3FXArYGh5RV2IEsJhEmLy6n445ZwdHGt5dOLCIIZf lux@lux-nixos"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
