{ flake, pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux isDarwin;
  inherit (flake.inputs) self;
  inherit (self.settings) adminUser;
in
{
  home-manager.users.${adminUser} = {
    home.packages = [ pkgs.omnix pkgs.git ];

    programs = {
      starship.enable = true;
      bash.enable = lib.mkIf isLinux true;
      zsh = lib.mkIf isDarwin {
        enable = true;
        envExtra = ''
          # Make Nix and home-manager installed things available in PATH.
          export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
        '';
      };
    };
    home.stateVersion = "24.05";
  };
}
