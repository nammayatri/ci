{ root, inputs, ... }:

{
  imports = [
    inputs.nixos-unified.flakeModules.default
    inputs.nixos-unified.flakeModules.autoWire
  ];

  flake.settings = import (root + /settings);
}
