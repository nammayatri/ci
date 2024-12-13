{
  nixConfig = { };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix.url = "github:ryantm/agenix";
    nixos-unified.url = "github:srid/nixos-unified";
    github-nix-ci.url = "github:juspay/github-nix-ci";
    omnix.url = "github:juspay/omnix";

    # NOTE: These inputs are shared with *all* hosts.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    harmonia.url = "github:nix-community/harmonia";
    harmonia.inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-parts.follows = "flake-parts";
    };
  };

  outputs = inputs:
    inputs.nixos-unified.lib.mkFlake { inherit inputs; root = ./.; };
}
