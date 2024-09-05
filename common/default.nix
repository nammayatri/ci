# Module common to all hosts
{ flake, pkgs, lib, ... }:
let
  inherit (flake.inputs.common.config) adminUser admins;
  inherit (flake.inputs) common;
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  # Packages
  environment.systemPackages = with pkgs; [
    # Useful packages to diagnose issues with server
    htop
    tailscale
  ];

  # Services
  services = lib.mkMerge [
    (lib.optionalAttrs isLinux {
      netdata.enable = true;
      openssh.enable = true;
    })
    (lib.optionalAttrs isDarwin {
      nix-daemon.enable = true;
    })
    {
      tailscale.enable = true;
    }
  ];

  # "admin" user
  users.users.${adminUser} = lib.mkMerge
    [
      (lib.optionalAttrs isLinux {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      })
      (lib.optionalAttrs isDarwin {
        name = adminUser;
        home = "/Users/${adminUser}";
      })
      {
        openssh.authorizedKeys.keys = lib.attrValues admins;
      }
    ];

  # Passwordless sudo
  security = lib.optionalAttrs isLinux {
    sudo.execWheelOnly = true;
    sudo.wheelNeedsPassword = false;
  };

  # Nix settings
  nix = {
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    settings = {
      max-jobs = "auto";
      experimental-features = "nix-command flakes repl-flake";
      # Nullify the registry for purity.
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      trusted-users = [
        "root"
        (if isDarwin then adminUser else "@wheel")
      ];
      # To allow building on rosetta
      extra-platforms = lib.mkIf isDarwin "aarch64-darwin x86_64-darwin";
    };
  };

  # Overlays
  nixpkgs.overlays = [
    (final: prev: {
      # Add custom packages here
      omnix = common.inputs.omnix.packages.${system}.default;
    })
  ];
}