{ ... }:

{
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /mnt 172.23.42.0/24(rw,fsid=0,insecure,no_subtree_check) fd00::/8(rw,fsid=0,insecure,no_subtree_check)
  '';
  networking.firewall.allowedTCPPorts = [ 2049 ];
}
