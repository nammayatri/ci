# https://x.com/nixos_asia/status/1840073743445491762
{ config, ... }:
{
  age.secrets = {
    "ny-ci-nixos-ssh.age" = {
      file = ../../secrets/ny-ci-nixos-ssh.age;
      owner = "root";
    };
  };

  nix.distributedBuilds = true;
  # This option allows remote builders to download dependencies directly from caches (like cache.nixos.org).
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
  nix.buildMachines = [
    {
      sshUser = "nix-user";
      hostName = "basantis-Mac-Studio";
      systems = [ "aarch64-darwin" "x86_64-darwin" ];
      sshKey = config.age.secrets."ny-ci-nixos-ssh.age".path;
    }
  ];
  services.openssh.knownHosts.basantis-Mac-Studio = {
    hostNames = [ "basantis-Mac-Studio" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL48yy04TzTi30iwNPr1LOvzOnwupL+yBvo5UXpPDLBh";
  };
}
