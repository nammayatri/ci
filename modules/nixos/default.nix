{ flake, ... }:

{
  imports = [
    flake.inputs.ragenix.nixosModules.default
    ./base.nix
    ./home.nix
  ];

  # https://discourse.nixos.org/t/nixos-rebuild-switch-upgrade-networkmanager-wait-online-service-failure/30746/2
  systemd.services.NetworkManager-wait-online.enable = false;
}
