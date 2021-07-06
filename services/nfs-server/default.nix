{ ... }:

{
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt 172.23.42.0/24(rw,fsid=0,insecure,no_subtree_check) fd00::/8(rw,fsid=0,insecure,no_subtree_check)
    '';

    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;
  };

  networking.firewall.interfaces.enp3s0.allowedTCPPorts = [ 2049 4000 4001 4002 111 ];
  networking.firewall.interfaces.enp3s0.allowedUDPPorts = [ 2049 4000 4001 4002 111 ];
}
