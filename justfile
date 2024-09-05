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

# Rekey all secrets (usually done after adding/removing hosts/users)
secrets-rekey:
    cd ./common/secrets && agenix -r
