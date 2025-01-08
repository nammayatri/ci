{
  nix = {
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 80 * 1024;
            memorySize = 24 * 1024;
          };
          cores = 6;
        };
      };
    };
  };
}
