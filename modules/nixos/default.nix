{ flake, ... }:

{
  imports = [
    flake.inputs.agenix.nixosModules.default
    ./common.nix
    ./base.nix
    ./home.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # https://discourse.nixos.org/t/nixos-rebuild-switch-upgrade-networkmanager-wait-online-service-failure/30746/2
  systemd.services.NetworkManager-wait-online.enable = false;
}
