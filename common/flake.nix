{
  inputs = {
    omnix.url = "github:juspay/omnix";
    ragenix.url = "github:yaxitech/ragenix";
    github-nix-ci.url = "github:juspay/github-nix-ci";
    nixos-flake.url = "github:srid/nixos-flake";
  };
  outputs = inputs: {
    nixosModules = {
      default = {
        imports = [
          ./default.nix
          ./home.nix
          inputs.ragenix.nixosModules.default
          inputs.github-nix-ci.nixosModules.default
        ];
      };

      github-runner = ./github-runner.nix;
    };

    config = import ./config;
  };
}
