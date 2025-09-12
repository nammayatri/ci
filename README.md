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

## Renewing GitHub Runner Token

When the GitHub runner token expires, follow these steps to create and encrypt a new token:

### 1. Create a New GitHub Fine-Grained Personal Access Token

1. Go to https://github.com/settings/personal-access-tokens/new
2. Configure the token:
   - **Token name**: `nammayatri-ci-runners`
   - **Resource owner**: `nammayatri`
   - **Repository access**: `All repositories` (or select specific repositories)
   - **Permissions** → Organization permissions → **Self-hosted runners**: `Read and write`
   - **Expiration**: Set your desired expiry date
3. Click **Generate token** and copy it

### 2. Encrypt the Token with Agenix

```bash
# Navigate to the secrets directory
cd secrets

# Extract recipients from secrets.nix and create temporary recipients file
nix-instantiate --json --eval --strict -E \
  '(let rules = import ./secrets.nix; in rules."github-nix-ci/nammayatri.token.age".publicKeys)' \
  | jq -r '.[]' > /tmp/recipients.txt

# Remove old encrypted token
rm github-nix-ci/nammayatri.token.age

# Encrypt the new token (replace YOUR_NEW_TOKEN with the actual token from step 1)
echo "YOUR_NEW_TOKEN" | age -e -R /tmp/recipients.txt > github-nix-ci/nammayatri.token.age

# Verify decryption works
age --decrypt --identity ~/.ssh/id_ed25519 github-nix-ci/nammayatri.token.age

# Clean up
rm /tmp/recipients.txt
```

### 3. Deploy the Updated Token

```bash
# Go back to repo root
cd ..

# Commit the new encrypted token
git add secrets/github-nix-ci/nammayatri.token.age
git commit -m "Update GitHub runner token"
git push

# Deploy to Mac Studio
just deploy-mac

# Deploy to NixOS (if needed)
just deploy-nixos
```

### 4. Verify Runners Are Working

Check that the runners started successfully:

```bash
# On Mac Studio, check runner services
sudo launchctl list | grep github-runner

# Check individual runner status
sudo launchctl print system/org.nixos.github-runner-basantis-mac-studio-nammayatri-01
```

Or check in GitHub: **Repository/Org Settings** → **Actions** → **Runners** - they should show as "Online" (green).

## Updating GitHub Runner Version

GitHub releases new runner versions every few months. To update the runners to the latest version:

```bash
# Update nixpkgs to get the latest runner version
nix flake update --commit-lock-file nixpkgs

# Deploy to both machines
just deploy-mac
just deploy-nixos
```

This will update the nixpkgs input in `flake.lock`, which includes the latest GitHub Actions runner version, and deploy it to both the Mac Studio and NixOS machines.

## Debugging Runners

### NixOS Machine (ny-ci-nixos)

The NixOS machine uses `systemctl` to manage runners:

```bash
# Check status of all runners
sudo systemctl status github-runner-*

# Restart all runners
sudo systemctl restart github-runner-*

# Check specific runner
sudo systemctl status github-runner-ny-ci-nixos-nammayatri-01

# View logs
sudo journalctl -u github-runner-ny-ci-nixos-nammayatri-01 -f
```

### Mac Studio (basantis-mac-studio)

The Mac Studio uses `launchctl` to manage runners:

```bash
# Check status of all runners at once
for i in 01 02 03 04; do
  echo "=== Runner $i ==="
  sudo launchctl print system/org.nixos.github-runner-basantis-mac-studio-nammayatri-$i | grep -E "(state|last exit code|runs)"
  echo
done

# Restart all runners at once
for i in 01 02 03 04; do
  echo "=== Restarting Runner $i ==="
  sudo launchctl kickstart -k system/org.nixos.github-runner-basantis-mac-studio-nammayatri-$i
done

# Check specific runner details
sudo launchctl print system/org.nixos.github-runner-basantis-mac-studio-nammayatri-01

# View logs for specific runner
sudo tail -f /var/log/github-runners/basantis-mac-studio-nammayatri-01/launchd-stderr.log
```
