{ ... }:

{
  fileSystems."/mnt" = {
    device = "core.lan:/";
    fsType = "nfs";
    options = [
      "nfsvers=4"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
    ];
  };
}
