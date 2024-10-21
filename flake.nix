{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    ragenix.url = "github:yaxitech/ragenix";
    nixos-unified.url = "github:srid/nixos-unified";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    inputs.nixos-unified.lib.mkFlake { inherit inputs; root = ./.; };
}
