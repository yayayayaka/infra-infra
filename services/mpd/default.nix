{ pkgs, config, ... }:

{
  imports = [
    #./mympd.nix
    ./ympd.nix
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/mukke";
    network.listenAddress = "any";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "pulse audio"
        server "localhost"
      }
    '';
  };

  networking.firewall.interfaces.enp3s0.allowedTCPPorts = [ config.services.mpd.network.port ];
}
