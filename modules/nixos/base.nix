# Module common to all hosts
{ flake, pkgs, lib, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
  inherit (self.settings) adminUser admins;
  inherit (pkgs.stdenv) isLinux isDarwin;
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
    # Linux-only services
    (lib.optionalAttrs isLinux {
      openssh.enable = true;
      netdata = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        package = pkgs.netdataCloud;
      };


    })

    # Services available on both Linux and Mac
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
    # package = pkgs.nixVersions.nix_2_23;
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    settings = {
      max-jobs = "auto";

      experimental-features = "nix-command flakes";
      # Nullify the registry for purity.
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      trusted-users = [
        "root"
        (if isDarwin then adminUser else "@wheel")
      ];
      # To allow building on rosetta
      extra-platforms = lib.mkIf isDarwin "aarch64-darwin x86_64-darwin";
    };

    # When disk space goes low (100GB left), run garbage collection until 1TB is free.
    # https://nixos.wiki/wiki/Storage_optimization#Automatic
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024 * 1024)}
    '';
  };


}
