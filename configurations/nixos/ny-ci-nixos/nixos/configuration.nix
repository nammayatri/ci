# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ny-ci-nixos";
  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  systemd.services.nix-cache-funnel = {
    description = "Tailscale Funnel for Nix Cache";

    after = [ "network-online.target" "tailscaled.service" ];
    wants = [ "network-online.target" "tailscaled.service" ];

    serviceConfig = {
      User = "root";

      ExecStart = "${pkgs.tailscale}/bin/tailscale funnel --https=443 http://127.0.0.1:80";

      Restart = "always";
      RestartSec = "10s";

      StartLimitIntervalSec = 60;
      StartLimitBurst = 5;
    };

    wantedBy = [ "multi-user.target" ];
  };
  

  systemd.services.check-github-runners = {
    description = "Check and Restart GitHub Runner Services";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /root/scripts/check-runners.sh";
      User = "root"; # Your script uses systemctl restart, which needs root.
    };
  };

  systemd.timers.check-github-runners = {
    description = "Run GitHub Runner Check Script periodically";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/11";
      Persistent = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}