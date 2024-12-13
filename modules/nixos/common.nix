{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{

  nix.settings = {
    # To workaround "stack overflow; max-call-depth exceeded" error from latest Nix when building nammayatri:
    # https://github.com/NixOS/nix/issues/9627
    # https://github.com/nix-community/robotnix/issues/224
    max-call-depth = 10000000;
  };

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
