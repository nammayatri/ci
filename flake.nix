{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      flake.om.ci.default =
        let
          hostsConfig =
            let
              inherit (inputs.nixpkgs.lib) listToAttrs nameValuePair attrNames;
              inherit (builtins) map readDir;
              overrideInputs = {
                common = ./common;
              };
              hosts = attrNames (readDir ./hosts);
              systems = {
                ny-ci-nixos = [ "x86_64-linux" ];
              };
              configForHost = name: {
                inherit overrideInputs;
                systems = systems.${name};
                dir = "./hosts/${name}";
              };
            in
            listToAttrs (map (name: nameValuePair name (configForHost name)) hosts);
        in
        hostsConfig // {
          root.dir = ".";
        };

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          name = "ny-ci-shell";
          packages = with pkgs; [
            just
          ];
        };
      };
    };
}
