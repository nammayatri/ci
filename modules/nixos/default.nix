{ flake, ... }:

{
  imports = [
    flake.inputs.ragenix.nixosModules.default
    ./base.nix
    ./home.nix
  ];
}
