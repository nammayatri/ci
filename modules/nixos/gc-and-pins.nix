{ flake, pkgs, lib, ... }:

let
  inherit (flake) inputs;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  # GC so the CI doesn't fill up the disk
  # See https://nixos.wiki/wiki/Storage_optimization#Automation
  nix.gc = {
    automatic = true;
    # dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Pin project outputs to avoid getting GC'ed
  # These outputs need to be persistent for CI & cache.
  home-manager.sharedModules =
    let
      pinNyFor = s: {
        "ci-pins/${s}/nammayatri".source = inputs.devour-flake.packages.${s}.default;
      };
      systemsToPin =
        if pkgs.stdenv.isLinux
        then [ system "aarch64-darwin" ]  # For Linux & macOS availability in our cache server
        else [ system "aarch64-linux" ]; # Native & ARM builds on macOS
    in
    [
      {
        home.file = lib.mkMerge (builtins.map pinNyFor systemsToPin);
      }
    ];
}
