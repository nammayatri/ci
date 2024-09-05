default:
    @just --list

# List hosts
hosts:
    ls ./hosts

# Auto-format source tree
fmt:
  nix fmt

# Deploy the given host (e.g.: `just deploy sambar`)
deploy HOST:
    nix run --override-input common ./common ./hosts/{{HOST}}#activate {{HOST}}
