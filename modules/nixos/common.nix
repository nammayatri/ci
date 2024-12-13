{ flake, pkgs, lib, ... }:
let
  inherit (flake) inputs;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{

  services.netdata = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    package = pkgs.netdataCloud;
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
