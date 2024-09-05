{ pkgs, ... }:
{
  services.github-nix-ci = {
    age.secretsDir = ./secrets;
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
      "nammayatri".num = 8;
    };
  };
}
