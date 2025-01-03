{ pkgs, ... }:
{
  services.github-nix-ci = {
    age.secretsDir = ../../secrets;
    runnerSettings = {
      extraPackages = with pkgs; [
        # Nix stuff
        omnix
        cachix
        openssh # flake inputs may use git+ssh

        # Docker
        docker

        # Basics
        bashInteractive
        coreutils
        curl
        gnumake
        git
      ];
    };
    orgRunners = {
      "nammayatri".num = 4;
    };
  };

  # GC so the CI doesn't fill up the disk
  # See https://nixos.wiki/wiki/Storage_optimization#Automation
  #
  # See also ~/gcroots
  nix.gc = {
    automatic = true;
    # dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
