{ pkgs, ... }:
{
  services.github-nix-ci = {
    age.secretsDir = ./secrets;
    runnerSettings = {
      extraPackages = with pkgs; [
        omnix
      ];
    };
    orgRunners = {
      "nammayatri".num = 2;
    };
  };
}
