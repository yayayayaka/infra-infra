{ pkgs, config, lib, ... }:

with lib;

let
  hosts = {
    ketchup = rec {
      magicNumber = 4;
      wireguard = {
        Endpoint = "195.39.221.190:51818";
        PublicKey = "ygGp0FG7qjFsikd4Dv/68olRFKIQDdt0xrpcoac8YE8=";
      };
    };
    tralphium = rec {
      magicNumber = 3;
      wireguard = {
        Endpoint = "185.133.208.146:51818";
        PublicKey = "BG2oXzv2qZnQTr+PjUoEMA+vG24g617L3+5TjqHycHk=";
      };
    };
    osmium = rec {
      magicNumber = 8;
      wireguard = {
        Endpoint = "5.199.141.154:51818";
        PublicKey = "kih/GnR4Bov/DM/7Rd21wK+PFQRUNH6sywVuNKkUAkk=";
      };
    };
  };

in {
  secrets.wireguard.owner = "systemd-network";

  environment.systemPackages = with pkgs; [ wireguard-tools ];

  networking.useNetworkd = true;

  networking.interfaces.lo = {
    ipv6.addresses = [
      { address = "2a0f:4ac0:af5a::1"; prefixLength = 128; }
    ];
    ipv4.addresses = [
      { address = "195.39.247.225"; prefixLength = 32; }
      { address = "127.0.0.53"; prefixLength = 8; }
    ];
  };

  systemd.network = {
    netdevs = mapAttrs' (name: host: nameValuePair "40-wg-${name}" {
      netdevConfig = {
        Name = "wg-${name}";
        Kind = "wireguard";
        MTUBytes = "1500";
      };
      wireguardConfig = {
        PrivateKeyFile = config.secrets.wireguard.path;
        FirewallMark = 51820;
        ListenPort = 18912 + host.magicNumber;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = host.wireguard // {
            PersistentKeepalive = 21;
            AllowedIPs = [ "0.0.0.0/0" "::/0" ];
          };
        }
      ];
    }) hosts;
    networks = (
      mapAttrs' (name: host: nameValuePair "40-wg-${name}" {
        name = "wg-${name}";
        addresses =  [
          { addressConfig.Address = "fdaf::${toString host.magicNumber}:2/112"; }
          { addressConfig.Address = "169.254.${toString host.magicNumber}.2/24"; }
        ];
      }) hosts
    ) // {
      "40-lo" = {
        extraConfig = ''
          # local routes
          [RoutingPolicyRule]
          Family=both
          SuppressPrefixLength=0
          Priority=1000

          # send wireguard to main table
          [RoutingPolicyRule]
          Family=both
          FirewallMark=51820
          Priority=3000

          # disallow any other routes for wireguard
          [RoutingPolicyRule]
          Family=both
          FirewallMark=51820
          Type=unreachable
          Priority=3001

          # local routes
          [RoutingPolicyRule]
          Family=both
          Table=1
          Priority=4000

          # bgp routes
          [RoutingPolicyRule]
          Family=both
          Table=2
          Priority=5000
        '';
      };
    };
  };

  services.bird2 = {
    enable = true;
    config = fileContents ./bird2.conf + concatStrings (mapAttrsToList (name: host: ''
      protocol bgp bgp_${name} {
        local as 64843;
        graceful restart on;

        ipv6 {
          igp table local6;
          export all;
          import filter {
            accept;
          };
        };
        ipv4 {
          igp table local4;
          export all;
          import filter {
            accept;
          };
        };

        source address fdaf::${toString host.magicNumber}:2;
        neighbor fdaf::${toString host.magicNumber}:1 as 207921;
      }
    '') hosts);
  };
}
