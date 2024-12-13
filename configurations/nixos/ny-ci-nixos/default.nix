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
    flake.inputs.github-nix-ci.nixosModules.default
    self.nixosModules.github-runner
    self.nixosModules.distributed-builds
    self.nixosModules.cache-server
    ./nixos/hardware-configuration.nix
    ./nixos/configuration.nix
    {
      system.stateVersion = "24.05";
    }
  ];
}
