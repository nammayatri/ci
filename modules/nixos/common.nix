{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{

  nixpkgs = {
    # For netdata
    config.allowUnfree = true;
    config.allowBroken = true;
    # Overlays
    overlays = [
      (final: prev: {
        # Add custom packages here
        omnix = inputs.omnix.packages.${system}.default;
      })
    ];
  };
}
