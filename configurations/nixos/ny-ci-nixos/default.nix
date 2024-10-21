{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  nixpkgs.hostPlatform = "x86_64-linux";
  nixos-unified = {
    sshTarget = "admin@ny-ci-nixos";
  };
  imports = [
    self.nixosModules.default
    self.nixosModules.github-runner
    ./nixos/hardware-configuration.nix
    ./nixos/configuration.nix
    {
      system.stateVersion = "24.05";
    }
  ];
}
