{
  perSystem = { inputs', pkgs, ... }: {
    formatter = pkgs.nixpkgs-fmt;

    devShells.default = pkgs.mkShell {
      name = "ny-ci-shell";
      packages = with pkgs; [
        just
        nixd
        inputs'.agenix.packages.default
      ];
    };
  };
}
