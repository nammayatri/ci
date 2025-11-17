{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.common
    self.darwinModules.default
    self.darwinModules.remote-builder
    self.darwinModules.aarch64-linux-builder
    flake.inputs.agenix.darwinModules.default
    flake.inputs.github-nix-ci.darwinModules.default
    self.nixosModules.github-runner
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "basantis-mac-studio";
  nixos-unified = {
    sshTarget = "nix-user@basantis-mac-studio";
  };

  # Configure agenix identity paths explicitly for Darwin
  age.identityPaths = [ "/Users/nix-user/.ssh/id_ed25519" ];

  # For home-manager to work.
  # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
  users.users."nix-user".home = "/Users/nix-user";
  # home-manager.users."nix-user" = { };
  
  # Disable home-manager version check
  home-manager.users."nix-user" = {
    home.enableNixpkgsReleaseCheck = false;
  };

  ids.gids.nixbld = 350;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}