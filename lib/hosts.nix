{ pkgs ? import ../pkgs { /* TODO system */} }:

with pkgs.lib;

rec {
  hostsDir = ../hosts;

  hostNames = attrNames (
    filterAttrs (
      name: type: type == "directory"
    ) (
      builtins.readDir hostsDir
    )
  );

  # HACK: We want to choose a nixpkgs version depending on the host architecture, but
  # the host architecture is set in the NixOS config. We accept the limitation that
  # nixpkgs.system must be set in the main configuration.nix file to prevent reading
  # the host configuration twice.
  hostArch = hostName:
    (
      (
        import (hostsDir + "/${hostName}/configuration.nix") {
          inherit (pkgs) pkgs lib;
          config = {};
          modulesPath = "";
        }
      ).nixpkgs or {}
    ).system or "x86_64-linux"
  ;

  nixpkgsFor = hostName: (import ../pkgs {
    system = hostArch hostName;
  }).path;

  hostConfig = hostName: { config, ... }: {
    _module.args = {
      inherit hosts groups;
    };
    imports = [
      (import (hostsDir + "/${hostName}/configuration.nix"))
      ../modules
    ];
    networking = {
      inherit hostName;
    };
    nixpkgs.pkgs = import ../pkgs {
      inherit (config.nixpkgs) config system;
    };
  };

  hosts = listToAttrs (
    map (
      hostName: nameValuePair hostName (
        import ((nixpkgsFor hostName) + "/nixos") {
          configuration = hostConfig hostName;
          system = hostArch hostName;
        }
      )
    ) hostNames
  );

  groupNames = unique (
    concatLists (
      mapAttrsToList (
        name: host: host.config.deploy.groups
      ) hosts
    )
  );

  groups = listToAttrs (
    map (
      groupName: nameValuePair groupName (
        filter (
          host: elem groupName host.config.deploy.groups
        ) (
          attrValues hosts
        )
      )
    ) groupNames
  );
}
