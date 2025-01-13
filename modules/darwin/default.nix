let
  # TODO: Consolidate with ${adminUser} when setting up new Mac
  macAdminUser = "nix-user";
in
{
  services = {
    nix-daemon.enable = true;
  };

  users.users.${macAdminUser} = {
    home = "/Users/${macAdminUser}";
  };
  home-manager.users.${macAdminUser} = {
    home.username = macAdminUser;
    home.stateVersion = "24.05";
  };
}
