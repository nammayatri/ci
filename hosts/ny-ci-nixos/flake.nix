{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    common = { };
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [ inputs.common.inputs.nixos-flake.flakeModule ];

      flake = {
        # Configurations for Linux (NixOS) machines
        nixosConfigurations.ny-ci-nixos = self.nixos-flake.lib.mkLinuxSystem {
          nixpkgs.hostPlatform = "x86_64-linux";
          nixos-flake = {
            sshTarget = "admin@ny-ci-nixos";
            overrideInputs = [ "common" ];
          };
          imports = [
            inputs.common.nixosModules.default
            inputs.common.nixosModules.github-runner
            self.nixosModules.home-manager
            ./nixos/hardware-configuration.nix
            ./nixos/configuration.nix
            {
              system.stateVersion = "24.05";
            }
          ];
        };
      };
    };
}
