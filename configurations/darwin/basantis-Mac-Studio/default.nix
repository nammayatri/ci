{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.darwinModules.default
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "basantis-Mac-Studio";
  nixos-unified = {
    sshTarget = "nix-user@basantis-Mac-Studio";
  };

  # For home-manager to work.
  # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
  users.users."nix-user".home = "/Users/nix-user";
  # home-manager.users."nix-user" = { };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
