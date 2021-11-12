{ system ? builtins.currentSystem }:

let
  sources = import ./sources.nix {};
  pkgs = import sources.nixpkgs { inherit system; };
  lib = pkgs.lib;
in
  pkgs.runCommand "sources" {} (
    lib.concatStringsSep "\n" ([
      "mkdir $out"
    ]
      ++ lib.mapAttrsToList (name: source: "ln -s ${source.outPath} $out/${name}") sources
    )
  )
