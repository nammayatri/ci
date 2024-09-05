# ci
CI for Nammayatri

## Deploying

In the nix shell, run:

```
just deploy ny-ci-nixos
```

>[!NOTE]
> This requires you to be connected to Nammayatri Tailscale network!

## Progress

- [x] NixOS CI: Running GitHub runners
- [x] Refactor to prepare for multiple hosts
- [ ] macOS CI: nix-darwin
