let
  inherit (import ../../../settings) admins;
  users = builtins.attrValues admins;

  ny-ci-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWODODitFFGrGbPRaw72O1/LCANtmQGIDwp2CGi+VOM root@nixos";
  systems = [ ny-ci-nixos ];
in
{
  # Public systems
  "hello.age".publicKeys = users ++ systems;
  "github-nix-ci/nammayatri.token.age".publicKeys = users ++ systems;
}
