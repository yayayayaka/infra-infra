let
  pkgs = import ./pkgs {
    system = if builtins ? currentSystem then builtins.currentSystem else "x86_64-linux";
  };
in {
  inherit pkgs;
  deploy = import ./lib/deploy.nix { inherit pkgs; };
}
  // (import ./lib/hosts.nix { inherit pkgs; })
