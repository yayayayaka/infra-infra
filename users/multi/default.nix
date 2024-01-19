{ pkgs, ... }:

{
  users.users.multi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWtfUhmD0hgr2u4EOfFUWsrtfxl9IZ9LGjqLjL/QzeN multi@flywheel"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDhio/0DSCdbAttE+v+exbjlmXTzVtS57ehU5JO4kIHL8MWM+7RLhodAtY5r4ZHWMtjWJteYnNlt+m3FGRjnj6A= multi@macbook"
    ];
    shell = pkgs.bash;
  };
}
