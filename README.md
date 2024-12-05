# ci

Nammayatri's CI machine configuration managed using [nixos-unified](https://nixos-unified.org/autowiring.html). We are responsible for this organization's Nix-native self-hosted runners.[^1]

[^1]: Uses https://github.com/juspay/github-ci-nix

## Deploying

To deploy the NixOS machine:

```
just deploy-nixos
```

To deploy to the Mac studio:

```
just deploy-mac
```

>[!NOTE]
> This requires you to
> - be connected to Nammayatri [Tailscale](https://login.tailscale.com/admin/machines) network,
> - be [an admin](https://github.com/nammayatri/ci/blob/main/common/config/default.nix)

## What's available

- NixOS CI
- macOS remote builder
- Harmonia Cache server
