{ flake, config, pkgs, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;

  domain = "ny-ci-nixos.betta-gray.ts.net"; # Tailscale funnel's domain
  # pubkey = "ny-ci-nixos.betta-gray.ts.net:tjYdPZNppaGd6L9m7cMGzib4kkch1zAuR660dYp1DiY="
in
{
  imports = [
    inputs.harmonia.nixosModules.harmonia
  ];

  services.harmonia-dev = {
    enable = true;
    signKeyPaths = [
      config.age.secrets."harmonia-secret.age".path
    ];
  };

  age.secrets = {
    "harmonia-secret.age" = {
      owner = "root";
      file = self + /secrets/harmonia-secret.age;
    };
  };

  services.nginx = {
    enable = true;
    package = pkgs.nginxStable.override {
      modules = [ pkgs.nginxModules.zstd ];
    };
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;
    virtualHosts.${domain} = {
      locations."/".extraConfig = ''
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;

        zstd on;
        zstd_types application/x-nix-archive;
      '';
    };
  };
}
