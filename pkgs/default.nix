{ config ? {}, system ? builtins.currentSystem, ... }@args:

let
  sources = import ../nix/sources.nix;

  pkgs = import sources.nixpkgs args;

  inherit (pkgs) lib;
  callPackage = lib.callPackageWith (pkgs // newpkgs);

  newpkgs = {
    /* ... */
  };

in pkgs // newpkgs
