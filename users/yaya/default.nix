{ ... }:

{
  users.users.yaya = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtsTZ07gkBSX5dcQBt/y6ECP4+oDdwG4Qjw495YIOWf"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm6dZQizYi97jRu4Kci0uADC1LRslL+rDG6Kg4grtsX"
    ];
  };
}
