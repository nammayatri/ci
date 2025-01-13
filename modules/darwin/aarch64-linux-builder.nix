{
  nix = {
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        nix.gc = {
          automatic = true;
          # dates = "weekly";
          options = "--delete-older-than 30d";
        };
        virtualisation = {
          darwin-builder = {
            diskSize = 160 * 1024;
            memorySize = 24 * 1024;
          };
          cores = 6;
        };
      };
    };
  };
}
