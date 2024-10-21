default:
    @just --list

# List hosts
hosts:
    ls ./configurations/{nixos,darwin}

# Auto-format source tree
fmt:
  nix fmt

# Deploy the given host (e.g.: `just deploy sambar`)
deploy HOST:
    nix run .#activate {{HOST}}

# Rekey all secrets (usually done after adding/removing hosts/users)
secrets-rekey:
    cd ./modules/nixos/secrets && agenix -r
