# ci
Nammayatri's CI machine configuration. We are responsible for this organization's Nix-native self-hosted runners.[^1]

[^1]: Uses https://github.com/juspay/github-ci-nix

## Deploying

In the nix shell, run:

```
just deploy ny-ci-nixos
```

>[!NOTE]
> This requires you to
> - be connected to Nammayatri [Tailscale](https://login.tailscale.com/admin/machines) network,
> - be [an admin](https://github.com/nammayatri/ci/blob/main/common/config/default.nix)

## Progress

- [x] NixOS CI: Running GitHub runners
- [x] Refactor to prepare for multiple hosts
- [ ] macOS CI: nix-darwin
