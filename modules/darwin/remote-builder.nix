# https://x.com/nixos_asia/status/1840073743445491762
{ flake, ... }:
{
  imports = [
    flake.inputs.agenix.nixosModules.default
  ];

  age.secretsDir = ../../secrets;

  nix.settings.trusted-users = [ "nix-user" ];
  users.users."nix-user" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKy1BnX1Q68dksiobV9znkwY/e3YIBQWiaBM1G7FLp3Q" # ny-ci-nixos
    ];
  };
}
