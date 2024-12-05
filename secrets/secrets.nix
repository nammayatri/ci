let
  inherit (import ../settings) admins;
  users = builtins.attrValues admins;

  ny-ci-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWODODitFFGrGbPRaw72O1/LCANtmQGIDwp2CGi+VOM root@nixos";
  basantis-Mac-Studio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL48yy04TzTi30iwNPr1LOvzOnwupL+yBvo5UXpPDLBh";
  systems = [
    ny-ci-nixos
    basantis-Mac-Studio
  ];
in
{
  # Public systems
  "hello.age".publicKeys = users ++ systems;
  "ny-ci-nixos-ssh.age".publicKeys = users ++ systems;
  "github-nix-ci/nammayatri.token.age".publicKeys = users ++ systems;
  "harmonia-secret.age".publicKeys = users ++ systems;
}
