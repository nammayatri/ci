{ root, inputs, ... }:

{
  flake = {
    om.ci.default =
      let
        hostsConfig =
          let
            inherit (inputs.nixpkgs.lib) listToAttrs nameValuePair attrNames;
            inherit (builtins) map readDir;
            overrideInputs = {
              common = ./common;
            };
            hosts = attrNames (readDir (root + /hosts));
            systems = {
              ny-ci-nixos = [ "x86_64-linux" ];
            };
            configForHost = name: {
              inherit overrideInputs;
              systems = systems.${name};
              dir = "${root}/${name}";
            };
          in
          listToAttrs (map (name: nameValuePair name (configForHost name)) hosts);
      in
      hostsConfig // {
        root.dir = ".";
      };
  };
}
